
if termination_status(model_name)==MathOptInterface.OPTIMAL || termination_status(model_name)==MathOptInterface.LOCALLY_SOLVED  || termination_status(model_name)==MathOptInterface.ALMOST_OPTIMAL || termination_status(model_name)==MathOptInterface.ALMOST_LOCALLY_SOLVED
save("repos\\feasible_result_TRACT_$(nam).jld2"
     ,"Pg",JuMP.value.(Pg)
     ,"Qg", JuMP.value.(Qg)
     ,"pen_lsh", JuMP.value.(pen_lsh)
     ,"pen_ws" ,JuMP.value.(pen_ws)

     ,"p_fl_inc", JuMP.value.(!isnothing(p_fl_inc) ? p_fl_inc : 0 )
     ,"p_fl_dec", JuMP.value.(!isnothing(p_fl_dec) ? p_fl_dec : 0 )
     ,"p_ch" ,JuMP.value.(!isnothing(p_ch) ? p_ch : 0 )
     ,"p_dis" ,JuMP.value.(!isnothing(p_dis) ? p_dis : 0 )
     ,"soc" ,JuMP.value.(!isnothing(soc) ? soc : 0 )
     ,"p_str" ,JuMP.value.(!isnothing(p_ch) ? p_ch : 0 )-value.(!isnothing(p_dis) ? p_dis : 0 )

     ,"Pg_c",JuMP.value.(Pg_c)
     ,"Qg_c", JuMP.value.(Qg_c)
     ,"pen_lsh_c", JuMP.value.(pen_lsh_c)
     ,"pen_ws_c" ,JuMP.value.(pen_ws_c)

     ,"p_fl_inc_c", JuMP.value.(!isnothing(p_fl_inc_c) ? p_fl_inc_c : 0 )
     ,"p_fl_dec_c", JuMP.value.(!isnothing(p_fl_dec_c) ? p_fl_dec_c : 0 )
     ,"p_str_c" ,JuMP.value.(!isnothing(p_ch_c) ? p_ch_c : 0 )-JuMP.value.(!isnothing(p_dis_c) ? p_dis_c : 0 )

     ,"cost_gen", JuMP.value.(cost_gen)
     ,"cost_fl" ,JuMP.value.(!isnothing(cost_fl) ? cost_fl : 0 )
     ,"cost_str" ,JuMP.value.(!isnothing(cost_str) ? cost_str : 0 )
     ,"cost_pen_lsh" ,JuMP.value.(!isnothing(cost_pen_lsh) ? cost_pen_lsh : 0 )
     ,"cost_pen_ws" ,JuMP.value.(!isnothing(cost_pen_ws) ? cost_pen_ws : 0 )

     ,"cost_fl_c" ,JuMP.value.(!isnothing(cost_fl_c) ? cost_fl_c : 0 )
     ,"cost_str_c" ,JuMP.value.(!isnothing(cost_str_c) ? cost_str_c : 0 )
     ,"cost_pen_lsh_c" ,JuMP.value.(!isnothing(cost_pen_lsh_c) ? cost_pen_lsh_c : 0 )
     ,"cost_pen_ws_c" ,JuMP.value.(!isnothing(cost_pen_ws_c) ? cost_pen_ws_c : 0 )

     ,"Objective",    JuMP.value.(cost_gen)
                    + JuMP.value.(!isnothing(cost_pen_lsh) ? cost_pen_lsh : 0 )[1]
                    + JuMP.value.(!isnothing(cost_pen_ws) ? cost_pen_ws : 0 )[1]
                    +JuMP.value.(!isnothing(cost_str_c) ? cost_str_c : 0 )[1]
                    + JuMP.value.(!isnothing(cost_fl_c) ? cost_fl_c : 0 )[1]

                    +JuMP.value.(!isnothing(cost_fl_c) ? cost_fl_c : 0 )[1]
                    +JuMP.value.(!isnothing(cost_str_c) ? cost_str_c : 0 )[1]
                    +JuMP.value.(!isnothing(cost_pen_lsh_c) ? cost_pen_lsh_c : 0 )[1]
                    +JuMP.value.(!isnothing(cost_pen_ws_c) ? cost_pen_ws_c : 0 )[1]
    , "time",    JuMP.solve_time(model_name)
      )
end



#
# load("repos\\feasible_result.jld2")["Objective"]
