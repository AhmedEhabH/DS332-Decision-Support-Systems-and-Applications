# Name: Ahmed Ehab Hussein
# ID: 20160007
# Group: CS_DS_1

using JuMP, GLPK


model = Model(optimizer_with_attributes(GLPK.Optimizer, "tm_lim" => 60000, "msg_lev" => GLPK.OFF))

println("let\n\tx1 be number of GE45,\n\tx2 be number of GE60")

@variable(model, 0<= x1)
@variable(model, 0<= x2)

@objective(model, Max, 50x1 + 75x2)

@constraint(model, Product, 2x1 + 2x2 <= 300)
@constraint(model, Assembly, 1x1 + 3x2 <= 240)

println(model)

optimize!(model)

println("Optimal Solutions:")
println("\'GE45\' x1 = ", round(value(x1), digits=0))
println("\'GE45\' x2 = ", round(value(x2), digits=0))
println("Objective value = ", objective_value(model))

println(termination_status(model))
println(primal_status(model))
println(dual_status(model))


if dual(Product) != 0 || dual(Assembly) != 0
    println("Allowable (decrease, increase) values for x1 \'GE45\': ", round.(lp_objective_perturbation_range(x1), digits=0))
    println("Allowable (decrease, increase) values for x2 \'GE60\': ", round.(lp_objective_perturbation_range(x2), digits=0))
end
