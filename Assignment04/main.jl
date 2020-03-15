using JuMP
using GLPK

mat = [
    0 1 1 1 0 0 0 0 0 0 0;
    1 0 1 1 0 0 0 0 0 0 0;
    1 1 0 1 0 0 0 0 0 0 0;
    1 1 1 0 0 1 0 0 1 1 0;
    0 0 0 0 0 1 1 0 0 0 0;
    0 0 0 1 1 0 0 0 1 1 0;
    0 0 0 0 1 0 0 1 1 0 0;
    0 0 1 0 0 0 1 0 1 0 0;
    0 0 0 1 0 1 1 1 0 1 0;
    0 0 0 1 0 1 0 0 1 0 1;
    0 0 0 0 0 0 0 0 0 1 0;
]

rows = size(mat, 1)
cols = size(mat, 2)

model = Model(optimizer_with_attributes(GLPK.Optimizer, "tm_lim" => 60000, "msg_lev" => GLPK.OFF))

@variable(model, color[1:cols], Bin)
@variable(model, v[1:rows, 1:cols], Bin)

@objective(model, Min, sum(color))

# make sure all vertices must be colored with at least one color
@constraint(model, [i=1:rows], sum(mat[i, h] * v[i, h] for h=1:cols) == 1)

# make sure any two adj nodes can't have the same color
for i=1:rows
    if sum(mat[i,:]) > 0
        @constraint(model, sum((mat[i, j] * v[i, j]) - color[j] for j=1:cols if mat[i, j] > 0) <=0)
    end
end

optimize!(model)

println("Model:")
println(model)


for i=1:rows
    for j=1:cols
        if value(v[i, j]) > 0
            println("v[$i, $j] = ", value(v[i, j]))
        end
    end
end

println()
for i in 1:cols
    println("color[$i] = ", value(color[i]))
    if value(color[i]) > 0
	println("This color will use")
    end
end

println("-" ^ 50)
println("Objective value = ", objective_value(model))
println("-" ^ 50)


