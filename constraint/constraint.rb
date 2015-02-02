require 'rglpk'

p = Rglpk::Problem.new
p.name = "sample"
p.obj.dir = Rglpk::GLP_MIN

rows = p.add_rows(3)
rows[0].name = "p"
rows[0].set_bounds(Rglpk::GLP_UP, 0, 100)
rows[1].name = "q"
rows[1].set_bounds(Rglpk::GLP_UP, 0, 600)
rows[2].name = "r"
rows[2].set_bounds(Rglpk::GLP_UP, 0, 300)

cols = p.add_cols(3)
cols[0].name = "x1"
cols[0].set_bounds(Rglpk::GLP_LO, 0.0, 0.0)
cols[1].name = "x2"
cols[1].set_bounds(Rglpk::GLP_LO, 0.0, 0.0)
cols[2].name = "x3"
cols[2].set_bounds(Rglpk::GLP_LO, 0.0, 0.0)

p.obj.coefs = [10, 6, 4]

p.set_matrix([
 1, 1, 1,
10, 4, 5,
 2, 2, 6
])

p.simplex
z = p.obj.get
x1 = cols[0].get_prim
x2 = cols[1].get_prim
x3 = cols[2].get_prim
