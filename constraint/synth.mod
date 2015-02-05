# A allocation problem
#
# Try to allocate synthesizers to hosts reducing links and avoiding core overload!
#
set H;
/* hosts */
set S;
/* synths */
param alpha integer; 
/* how important is overflow */
param cores{h in H} integer;
/* cores of hosts */
set c{S};
/* connection array */
var a{h in H, s in S} >= 0;
/* allocation array! */
var overflow{h in H} >= 0;
/* overflow of cores */
var locals{h in H,s in S,t in S} >= 0 binary;

minimize cost: 
	alpha * sum{h in H} (overflow[h]) +
        sum{s in S} card(c[s]) -     
        sum{h in H, s in S, t in c[s]} locals[h,s,t];
/* alrighty so we can't multiply or do ands or anything smart :(
   so we instead boost some value to be larger in the case of local connections
*/
/* ^^^ remotes is complicated! */
s.t. assign{s in S}: sum{h in H} a[h,s] = 1;
/* the constraint of assign it to 1 host */
s.t. corecheck2{h in H}: overflow[h] >= 0;
s.t. corecheck3{h in H}: overflow[h] >= sum{s in S}(a[h,s]) - cores[h];
/* This calculates overload - cheap maximum function*/
s.t. localcheck1{h in H,s in S,t in c[s]}: locals[h,s,t] <= a[h,s];
s.t. localcheck2{h in H,s in S,t in c[s]}: locals[h,s,t] <= a[h,t];
/* This following section needs to be generated carefully */
data;

set H := Host_Host_Big Host_Host_One Host_Host_Two Host_Host_Three Host_Host_Four;

set S := Synth_adc Synth_fm_1 Synth_lp_1 Synth_lp_2 Synth_dac;

param alpha := 100;

param cores := Host_Host_Big 2 Host_Host_One 1 Host_Host_Two 1 Host_Host_Three 1 Host_Host_Four 1;


set c[Synth_adc] := Synth_lp_1 ;

set c[Synth_fm_1] := Synth_lp_1 Synth_dac ;

set c[Synth_lp_1] := Synth_lp_2 Synth_dac ;

set c[Synth_lp_2] := Synth_dac ;

set c[Synth_dac] :=  ;


