using XLSX, DataFrames
if empty_contin==0

# Pg=load("repos\\feasible_result.jld2")["Pg"]
# Qg=load("repos\\feasible_result.jld2")["Qg"]
# pen_lsh=load("repos\\feasible_result.jld2")["pen_lsh"]
# pen_ws=load("repos\\feasible_result.jld2")["pen_ws"]
p_fl_inc=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_inc"]*sbase
p_fl_dec=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_dec"]*sbase
p_ch=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_ch"]*sbase
p_dis=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_dis"]*sbase
soc=load("repos\\feasible_result_TRACT_$(nam).jld2")["soc"]*sbase
# p_str=load("repos\\feasible_result.jld2")["p_str"]
# Pg_c=load("repos\\feasible_result.jld2")["Pg_c"]
# Qg_c=load("repos\\feasible_result.jld2")["Qg_c"]
# pen_lsh_c=load("repos\\feasible_result.jld2")["pen_lsh_c"]
# pen_ws_c=load("repos\\feasible_result.jld2")["pen_ws_c"]
# p_fl_inc_c=load("repos\\feasible_result.jld2")["p_fl_inc_c"]
# p_fl_dec_c=load("repos\\feasible_result.jld2")["p_fl_dec_c"]
# p_str_c=load("repos\\feasible_result.jld2")["p_str_c"]

# cost_gen=load("repos\\feasible_result.jld2")["cost_gen"]
# cost_fl=load("repos\\feasible_result.jld2")["cost_fl"]
# cost_str=load("repos\\feasible_result.jld2")["cost_str"]
# cost_pen_lsh=load("repos\\feasible_result.jld2")["cost_pen_lsh"]
# cost_pen_ws=load("repos\\feasible_result.jld2")["cost_pen_ws"]
# cost_fl_c=load("repos\\feasible_result.jld2")["cost_fl_c"]
# cost_str_c=load("repos\\feasible_result.jld2")["cost_str_c"]
# cost_pen_lsh_c=load("repos\\feasible_result.jld2")["cost_pen_lsh_c"]
# cost_pen_ws_c=load("repos\\feasible_result.jld2")["cost_pen_ws_c"]
# Objective=load("repos\\feasible_result.jld2")["Objective"]
# time=load("repos\\feasible_result.jld2")["time"]

# We need to round the result for better understanding
# PG=round.(Pg, digits=3)
# QG=round.(Qg, digits=3)
#
# LSH=round.(pen_lsh, digits=3 )
# WS=round.(pen_ws, digits=3 )
# XLSX.writexlsx("output_data\\output_T4_5", iman, overwrite=true )


XLSX.openxlsx("output_data/output_to_T45/procured_flexibility_$(nam)_$(yr)_$(sw)_$(wf).xlsx", mode="w") do xf
# First of all set the first sheet name
    # XLSX.rename!(xf[1], "ESS_CH_MW")

# #xf[1] menas the first sheet
#     xf[1]["A1"] = "Gen_nodes"
#     xf[1]["A2", dim=1]= bus_data_gsheet
#
#     Pg_vect = Vector()
#     for t in 1:nTP
#         push!(Pg_vect,PG[t,:] )
#     end
#     labels=["t$t" for t in 1:nTP]
#
#     XLSX.writetable!(xf[1], Pg_vect, labels, anchor_cell=XLSX.CellRef("B1"))
#---------------------------------------------------------------------
    # XLSX.addsheet!(xf, "Reactive_Power")

# #xf[1] menas the first sheet
#     xf[2]["A1"] = "Gen_nodes"
#     xf[2]["A2", dim=1]= bus_data_gsheet
#
#     Qg_vect = Vector()
#     for t in 1:nTP
#         push!(Qg_vect,QG[t,:] )
#     end
#     labels=["t$t" for t in 1:nTP]
#
#     XLSX.writetable!(xf[2], Qg_vect, labels, anchor_cell=XLSX.CellRef("B1"))
#--------------------------------------------------------------------
 labels=["t$t" for t in 1:nTP]

     XLSX.rename!(xf[1], "FL_OD_MW")
     xf[1]["A1"] = "Nodes"

     XLSX.addsheet!(xf, "FL_UD_MW")
     xf[2]["A1"] = "Nodes"

     if nFl!=0
         FL_inc=round.(p_fl_inc, digits=3)
         FL_dec=round.(p_fl_dec, digits=3)
     xf[1]["A2", dim=1]= nd_fl
        Fl_vect_inc = Vector()
          for t in 1:nTP
           push!(Fl_vect_inc,FL_inc[t,:] )
           end
    XLSX.writetable!(xf[1], Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))


    xf[2]["A2", dim=1]= nd_fl
       Fl_vect_dec = Vector()
         for t in 1:nTP
          push!(Fl_vect_dec,FL_dec[t,:] )
          end
   XLSX.writetable!(xf[2], Fl_vect_dec, labels, anchor_cell=XLSX.CellRef("B1"))

      end


      XLSX.addsheet!(xf, "ESS_CH_MW")
      xf[3]["A1"] = "Nodes"

      if nStr_active!=0

          STR_ch=round.((p_ch), digits=3)
          # STR=round.(STR, digits=3)




          xf[3]["A2", dim=1]= nd_Str_active
             STR_ch_vect = Vector()
               for t in 1:nTP
                push!(STR_ch_vect,STR_ch[t,:] )
                end
         XLSX.writetable!(xf[3], STR_ch_vect, labels, anchor_cell=XLSX.CellRef("B1"))
     end



     XLSX.addsheet!(xf, "ESS_DCH_MW")
     xf[4]["A1"] = "Nodes"

     if nStr_active!=0

         STR_dis=round.((p_dis), digits=3)
         # STR=round.(STR, digits=3)




         xf[4]["A2", dim=1]= nd_Str_active
            STR_dis_vect = Vector()
              for t in 1:nTP
               push!(STR_dis_vect,STR_dis[t,:] )
               end
        XLSX.writetable!(xf[4], STR_dis_vect, labels, anchor_cell=XLSX.CellRef("B1"))
    end



         XLSX.addsheet!(xf, "ESS_SOC")
         xf[5]["A1"] = "Nodes"

         if nStr_active!=0

             STR_soc=round.((soc), digits=3)
             # STR=round.(STR, digits=3)




             xf[5]["A2", dim=1]= nd_Str_active
                STR_soc_vect = Vector()
                  for t in 1:nTP
                   push!(STR_soc_vect,STR_soc[t,:] )
                   end
            XLSX.writetable!(xf[5], STR_soc_vect, labels, anchor_cell=XLSX.CellRef("B1"))
        end


#      XLSX.addsheet!(xf, "Load_curtailment")
#      xf[6]["A1"] = "Load_nodes"
#      xf[6]["A2", dim=1]= bus_data_lsheet
#         lsh_vect = Vector()
#           for t in 1:nTP
#            push!(lsh_vect,LSH[t,:] )
#            end
#     XLSX.writetable!(xf[6], lsh_vect, labels, anchor_cell=XLSX.CellRef("B1"))
# # if !isempty(RES_bus)
#     XLSX.addsheet!(xf, "RES_curtailment")
#     xf[7]["A1"] = "RES_nodes"
#     xf[7]["A2", dim=1]= RES_bus
#        ws_vect = Vector()
#          for t in 1:nTP
#           push!(ws_vect,WS[t,:] )
#           end
#    XLSX.writetable!(xf[7], ws_vect, labels, anchor_cell=XLSX.CellRef("B1"))
# # end
#    XLSX.addsheet!(xf, "COSTS")
#    xf[8]["A1"] = "Generation Cost"
#    xf[8]["B1"] = round.(cost_gen, digits=3)
# if  nFl!=0
#    xf[8]["A2"] = "Flexibility Cost"
#    if round.(cost_fl, digits=3)[1]>=0
#    xf[8]["B2"] = round.(cost_fl, digits=3)
#    else
#    xf[8]["B2"] = 0
#    end
# end
# if nStr_active!=0
#    xf[8]["A3"] = "Storage Cost"
#    if round.(cost_str, digits=3)[1]>= 0
#    xf[8]["B3"] = round.(cost_str, digits=3)
#    else
#    xf[8]["B3"] = 0
#    end
# end
#    xf[8]["A4"] = "Load curt. Cost"
#    if round.(cost_pen_lsh, digits=3)[1]>=0
#    xf[8]["B4"] = round.(cost_pen_lsh, digits=3)
#    else
#    xf[8]["B4"] = 0
#    end
#
# if !isempty(RES_bus)
#    xf[8]["A5"] = "RES curt. Cost"
#    if round.(cost_pen_ws, digits=3)[1]>=0
#    xf[8]["B5"] = round.(cost_pen_ws, digits=3)
#    else
#    xf[8]["B5"] = 0
#    end
# end
#    xf[8]["A6"] = "Total Cost"
#     penlsh = round.( cost_pen_lsh , digits=3)[1]
#     penlsh =[penlsh>=0 ? penlsh : 0][1]
#     penws  = round.( cost_pen_ws, digits=3)[1]
#     penws  =[penws>=0 ? penws : 0][1]
#     str   =round.( cost_str , digits=3)[1]
#     str  =[str>=0 ? str : 0][1]
#     fl    =round.( cost_fl, digits=3)[1]
#     fl =[fl>=0 ? fl : 0][1]
#       xf[8]["B6"] = cost_gen+ penlsh + penws +str + fl
#
#    xf[8]["A7"] = "Elapsed time"
#    xf[8]["B7"] = time




end
elseif empty_contin==1
    XLSX.openxlsx("output_data/output_to_T45/procured_flexibility_$(nam)_$(yr)_$(sw)_$(wf).xlsx", mode="w") do xf

        labels=["t$t" for t in 1:nTP]

            XLSX.rename!(xf[1], "FL_OD_MW")
            xf[1]["A1"] = "Nodes"

            XLSX.addsheet!(xf, "FL_UD_MW")
            xf[2]["A1"] = "Nodes"

            XLSX.addsheet!(xf, "ESS_CH_MW")
            xf[3]["A1"] = "Nodes"

           XLSX.addsheet!(xf, "ESS_DCH_MW")
           xf[4]["A1"] = "Nodes"

            XLSX.addsheet!(xf, "ESS_SOC")
               xf[5]["A1"] = "Nodes"

            #
            # if nFl!=0
            #     FL_inc=round.(p_fl_inc, digits=3)
            #     # FL_dec=round.(p_fl_dec, digits=3)
            # xf[1]["A2", dim=1]= nd_fl
            #    Fl_vect_inc = Vector()
            #      for t in 1:nTP
            #       push!(Fl_vect_inc,FL_inc[t,:] )
            #       end
            if nFl==0
           XLSX.writetable!(xf[1],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
           XLSX.writetable!(xf[2],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
       elseif nFl!=0
           xf[1]["A2", dim=1]= nd_fl
           xf[2]["A2", dim=1]= nd_fl
           Fl_vect_inc = Vector()
             for t in 1:nTP
              push!(Fl_vect_inc,zeros(1,nFl) )
             end
           XLSX.writetable!(xf[1],  Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
           XLSX.writetable!(xf[2],  Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))

       end
       if nStr==0
      XLSX.writetable!(xf[3],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
      XLSX.writetable!(xf[4],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
      XLSX.writetable!(xf[5],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
  elseif nStr!=0
      xf[3]["A2", dim=1]= nd_Str_active
      xf[4]["A2", dim=1]= nd_Str_active
      xf[5]["A2", dim=1]= nd_Str_active

      st_vect_inc = Vector()
        for t in 1:nTP
         push!(st_vect_inc,zeros(1,nStr) )
        end
        XLSX.writetable!(xf[3],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[4],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[5],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))

  end

end
end
# out_put_to_excel()
