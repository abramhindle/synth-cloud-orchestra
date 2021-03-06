var instance;

var nodes = [];
var connections = [];

function deleteNode(domNode) {
    domNode.remove();
    jsp.detachAllConnections(domNode);
    update();
}


function parseDesc(desc) {
    return desc.split(' ');
}

function mkSynth(text) {
    var data = {};
    updateSynth(data, text);
    return data;
}
function updateSynth(data,text) {
    var v = parseDesc(text);
    data["name"] = v[0];
    data["module"] = v[1]; 
}

function getData(domNode) {
    var data = domNode.data;
    if (!data) {
        data = mkSynth(domNode.children[0].value);
        domNode.data = data;
    }  else {
        updateSynth(data, domNode.children[0].value);
    }
    return data;
}

function select(domNode) {
    var data = domNode.data;
    if (!data) {
        data = mkSynth(domNode.children[0].value);
    }
    fillAttrs(data);    
    update();
}

function fillAttrs(data) {
    $("#attrs").empty();
    for (var k in data) {
        var ip = $("#inputproto").clone();
	ip.attr('id',mkid());
        ip.children()[0].value = k;
        ip.children()[1].value = data[k]||"";
        $("#attrs").append( ip );
    }    
    var ip = $("#inputproto").clone();
    ip.attr('id',mkid());
    $("#attrs").append( ip );
    
}
function updateJSON() {
    var json = generateJSON();
    console.log(json);
    $("#jsonout").val(json);
}
function generateJSON() {
    var nodes = $(".w").map( function(i,x){ return getData(x) } );
    var connections = jsp.getAllConnections();
    var conns = connections.map( function(s) {
        var src = getData(s.source).name
        var sink = getData(s.target).name
        return {"source":src, "sink":sink}
    });
    var nodehash = {};
    for (var i = 0 ; i < nodes.length; i++) {
        var node = nodes[i];
        nodehash[node.name] = node;
    }
    return JSON.stringify({
        "type":"synthdef",
        "blocks": nodehash,
        "connections":conns
    },null,"  ");
}
function mkid() {
	return "id"+Math.random().toString(36).substr(2,8);
}

function newObject() {
	var obj = $("#proto").clone();
	obj.attr('id',mkid());
        obj.attr('class','w');
	$("#statemachine-demo").append(obj);
	initWindow(obj); 
    update();
}

var listeners = [];
function update() {
    updateJSON();
}

function initWindow(w) {
	instance.draggable(w);
	instance.doWhileSuspended(function() {
		instance.makeSource(w, {
			filter:".ep",
			anchor:"Continuous",
			connector:[ "StateMachine", { curviness:20 } ],
			connectorStyle:{ strokeStyle:"#5c96bc", lineWidth:2, outlineColor:"transparent", outlineWidth:4 },
			maxConnections:5,
			onMaxConnections:function(info, e) {
				alert("Maximum connections (" + info.maxConnections + ") reached");
			}
		});
	});
	instance.makeTarget(w, {
		dropOptions:{ hoverClass:"dragHover" },
		anchor:"Continuous",
		allowLoopback:true
	});

}
jsPlumb.ready(function() {

	// setup some defaults for jsPlumb.
	instance = jsPlumb.getInstance({
		Endpoint : ["Dot", {radius:2}],
		HoverPaintStyle : {strokeStyle:"#1e8151", lineWidth:2 },
		ConnectionOverlays : [
			[ "Arrow", {
				location:1,
				id:"arrow",
                length:14,
                foldback:0.8
			} ],
            [ "Label", { label:"FOO", id:"label", cssClass:"aLabel" }]
		],
		Container:"statemachine-demo"
	});

    window.jsp = instance;

	var windows = jsPlumb.getSelector(".statemachine-demo .w");

    // initialise draggable elements.
	instance.draggable(windows);

    // bind a click listener to each connection; the connection is deleted. you could of course
	// just do this: jsPlumb.bind("click", jsPlumb.detach), but I wanted to make it clear what was
	// happening.
	instance.bind("click", function(c) {
		instance.detach(c);
	});

	// bind a connection listener. note that the parameter passed to this function contains more than
	// just the new connection - see the documentation for a full list of what is included in 'info'.
	// this listener sets the connection's internal
	// id as the label overlay's text.
    instance.bind("connection", function(info) {
		info.connection.getOverlay("label").setLabel(info.connection.id);
    });


	// suspend drawing and initialise.
	instance.doWhileSuspended(function() {
		var isFilterSupported = instance.isDragFilterSupported();
		// make each ".ep" div a source and give it some parameters to work with.  here we tell it
		// to use a Continuous anchor and the StateMachine connectors, and also we give it the
		// connector's paint style.  note that in this demo the strokeStyle is dynamically generated,
		// which prevents us from just setting a jsPlumb.Defaults.PaintStyle.  but that is what i
		// would recommend you do. Note also here that we use the 'filter' option to tell jsPlumb
		// which parts of the element should actually respond to a drag start.
		// here we test the capabilities of the library, to see if we
		// can provide a `filter` (our preference, support by vanilla
		// jsPlumb and the jQuery version), or if that is not supported,
		// a `parent` (YUI and MooTools). I want to make it perfectly
		// clear that `filter` is better. Use filter when you can.
		if (isFilterSupported) {
			instance.makeSource(windows, {
				filter:".ep",
				anchor:"Continuous",
				connector:[ "StateMachine", { curviness:20 } ],
				connectorStyle:{ strokeStyle:"#5c96bc", lineWidth:2, outlineColor:"transparent", outlineWidth:4 },
				maxConnections:5,
				onMaxConnections:function(info, e) {
					alert("Maximum connections (" + info.maxConnections + ") reached");
				}
			});
		}
		else {
			var eps = jsPlumb.getSelector(".ep");
			for (var i = 0; i < eps.length; i++) {
				var e = eps[i], p = e.parentNode;
				instance.makeSource(e, {
					parent:p,
					anchor:"Continuous",
					connector:[ "StateMachine", { curviness:20 } ],
					connectorStyle:{ strokeStyle:"#5c96bc",lineWidth:2, outlineColor:"transparent", outlineWidth:4 },
					maxConnections:5,
					onMaxConnections:function(info, e) {
						alert("Maximum connections (" + info.maxConnections + ") reached");
					}
				});
			}
		}
	});

	// initialise all '.w' elements as connection targets.
	instance.makeTarget(windows, {
		dropOptions:{ hoverClass:"dragHover" },
		anchor:"Continuous",
		allowLoopback:true
	});

	// and finally, make a couple of connections
	//instance.connect({ source:"opened", target:"phone1" });
	//instance.connect({ source:"phone1", target:"phone1" });
	//instance.connect({ source:"phone1", target:"inperson" });

	jsPlumb.fire("jsPlumbDemoLoaded", instance);

});
