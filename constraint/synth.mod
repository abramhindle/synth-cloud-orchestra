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
minimize cost: 
	alpha * sum{h in H} (overflow[h]) +
        sum{s in S} card(c[s]) -     
	(
		sum{h in H, s in S, t in S: s <> t}2*(a[h,s] + a[h,t])
		- sum{h in H, s in S, t in S: s <> t}a[h,s]
		- sum{h in H, s in S, t in S: s <> t}a[h,t]
	);
/* alrighty so we can't multiply or do ands or anything smart :(
   so we instead boost some value to be larger in the case of local connections
*/
/* ^^^ remotes is complicated! */
s.t. assign{s in S}: sum{h in H} a[h,s] = 1;
/* the constraint of assign it to 1 host */
s.t. corecheck2{h in H}: overflow[h] >= 0;
s.t. corecheck3{h in H}: overflow[h] >= sum{s in S}(a[h,s]) - cores[h];
/* This calculates overload - cheap maximum function*/
/* This following section needs to be generated carefully */
data;

set H := Host1 Host2 Host3 Host4;

set S := Adc Fm1 Lp1 Lp2 Dac;

param alpha := 100;

param cores := Host1   2
               Host2   1
               Host3   1
               Host4   1;
set c[Adc] := Lp1;
set c[Fm1] := Lp1 Dac;
set c[Lp1] := Lp2 Dac;
set c[Lp2] := Dac;
set c[Dac] :=;

