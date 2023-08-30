using XLSX#, DataFrames
function output_opf()
# We need to round the result for better understanding
PG=round.(value.(Pg), digits=3)
QG=round.(value.(Qg), digits=3)

LSH=round.(value.(pen_lsh), digits=3 )
WS=round.(value.(pen_ws), digits=3 )

XLSX.openxlsx("output_data\\$(nam)_$(yr)_$(sw)_$(wf)_Normal.xlsx", mode="w") do xf
# First of all set the first sheet name
    XLSX.rename!(xf[1], "Active_power")

#xf[1] menas the first sheet
    xf[1]["A1"] = "Gen_nodes"
    xf[1]["A2", dim=1]= bus_data_gsheet

    Pg_vect = Vector()
    for t in 1:nTP
        push!(Pg_vect,PG[t,:] )
    end
    labels=["t$t" for t in 1:nTP]

    XLSX.writetable!(xf[1], Pg_vect, labels, anchor_cell=XLSX.CellRef("B1"))
#---------------------------------------------------------------------
    XLSX.addsheet!(xf, "Reactive_Power")

#xf[1] menas the first sheet
    xf[2]["A1"] = "Gen_nodes"
    xf[2]["A2", dim=1]= bus_data_gsheet

    Qg_vect = Vector()
    for t in 1:nTP
        push!(Qg_vect,QG[t,:] )
    end
    labels=["t$t" for t in 1:nTP]

    XLSX.writetable!(xf[2], Qg_vect, labels, anchor_cell=XLSX.CellRef("B1"))
#--------------------------------------------------------------------

     XLSX.addsheet!(xf, "FL_inc")
     xf[3]["A1"] = "Flex_nodes"

     XLSX.addsheet!(xf, "FL_dec")
     xf[4]["A1"] = "Flex_nodes"

     if nFl!=0
         FL_inc=round.(value.(p_fl_inc), digits=3)
         FL_dec=round.(value.(p_fl_dec), digits=3)
     xf[3]["A2", dim=1]= nd_fl
        Fl_vect_inc = Vector()
          for t in 1:nTP
           push!(Fl_vect_inc,FL_inc[t,:] )
           end
    XLSX.writetable!(xf[3], Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))


    xf[4]["A2", dim=1]= nd_fl
       Fl_vect_dec = Vector()
         for t in 1:nTP
          push!(Fl_vect_dec,FL_dec[t,:] )
          end
   XLSX.writetable!(xf[4], Fl_vect_dec, labels, anchor_cell=XLSX.CellRef("B1"))

      end
      XLSX.addsheet!(xf, "STR")
      xf[5]["A1"] = "STR_nodes"

      if nStr_active!=0

          STR=round.((value.(p_ch)-value.(p_dis)), digits=3)
          # STR=round.(STR, digits=3)




          xf[5]["A2", dim=1]= nd_Str_active
             STR_vect = Vector()
               for t in 1:nTP
                push!(STR_vect,STR[t,:] )
                end
         XLSX.writetable!(xf[5], STR_vect, labels, anchor_cell=XLSX.CellRef("B1"))
     end

     XLSX.addsheet!(xf, "Load_curtailment")
     xf[6]["A1"] = "Load_nodes"
     xf[6]["A2", dim=1]= bus_data_lsheet
        lsh_vect = Vector()
          for t in 1:nTP
           push!(lsh_vect,LSH[t,:] )
           end
    XLSX.writetable!(xf[6], lsh_vect, labels, anchor_cell=XLSX.CellRef("B1"))
# if !isempty(RES_bus)
    XLSX.addsheet!(xf, "RES_curtailment")
    xf[7]["A1"] = "RES_nodes"
    xf[7]["A2", dim=1]= RES_bus
       ws_vect = Vector()
         for t in 1:nTP
          push!(ws_vect,WS[t,:] )
          end
   XLSX.writetable!(xf[7], ws_vect, labels, anchor_cell=XLSX.CellRef("B1"))
# end
   XLSX.addsheet!(xf, "COSTS")
   xf[8]["A1"] = "Genereation Cost"
   xf[8]["B1"] = round.(value.(cost_gen), digits=3)
if  nFl!=0
   xf[8]["A2"] = "Flexibility Cost"
   xf[8]["B2"] = round.(value.(cost_fl), digits=3)
end
if nStr_active!=0
   xf[8]["A3"] = "Storage Cost"
   xf[8]["B3"] = round.(value.(cost_str), digits=3)
end
   xf[8]["A4"] = "Load curt. Cost"
   if value.(cost_pen_lsh)[1]< 0
   xf[8]["B4"] = 0
    else
   xf[8]["B4"] = round.(value.(cost_pen_lsh), digits=3)
   end
if !isempty(RES_bus)
   xf[8]["A5"] = "RES curt. Cost"
   if value.(cost_pen_ws)[1]<0
   xf[8]["B5"] = 0
   else
   xf[8]["B5"] = round.(value.(cost_pen_ws), digits=3)
   end
end
   xf[8]["A6"] = "Total Cost"
   xf[8]["B6"] = round.(JuMP.objective_value(model_name), digits=3)

   xf[8]["A7"] = "Elapsed time "
   xf[8]["B7"] = round.(JuMP.solve_time(model_name), digits=3)




end
end
if empty_contin==0
output_opf()
end
