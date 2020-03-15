# Name: Ahmed Ehab Hussein
# Id: 20160007
# Group: CS-DS-1

using JuMP, GLPK

number_of_vertex = 6

arr = [
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    1 0 0 0 1 0;
    0 1 0 0 1 0;
    0 0 1 1 0 1;
    0 0 0 0 1 0
]

model = Model(optimizer_with_attributes(GLPK.Optimizer, "tm_lim" => 60000, "msg_lev" => GLPK.OFF))

@variable(model, v[1:number_of_vertex], Bin)

@objective(model, Min, sum(v))

@constraint(model, [j=1:number_of_vertex], sum(arr[j, i] * v[i] for i in 1:number_of_vertex if i != j) >= 1)

optimize!(model)
println("Model:")
println(model)
println("Objective value = ", objective_value(model))
for i in 1:6
    println("v[$i] = ", value(v[i]))
end
