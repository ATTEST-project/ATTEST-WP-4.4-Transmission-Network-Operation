using XLSX, DataFrames
function out_put_to_excel()


Pg=load("repos\\feasible_result_TRACT_$(nam).jld2")["Pg"]
Qg=load("repos\\feasible_result_TRACT_$(nam).jld2")["Qg"]
pen_lsh=load("repos\\feasible_result_TRACT_$(nam).jld2")["pen_lsh"]
pen_ws=load("repos\\feasible_result_TRACT_$(nam).jld2")["pen_ws"]
p_fl_inc=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_inc"]
p_fl_dec=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_dec"]
p_str=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_str"]
Pg_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["Pg_c"]
Qg_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["Qg_c"]
pen_lsh_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["pen_lsh_c"]
pen_ws_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["pen_ws_c"]
p_fl_inc_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_inc_c"]
p_fl_dec_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_fl_dec_c"]
p_str_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["p_str_c"]

cost_gen=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_gen"]
cost_fl=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_fl"]
cost_str=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_str"]
cost_pen_lsh=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_pen_lsh"]
cost_pen_ws=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_pen_ws"]
cost_fl_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_fl_c"]
cost_str_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_str_c"]
cost_pen_lsh_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_pen_lsh_c"]
cost_pen_ws_c=load("repos\\feasible_result_TRACT_$(nam).jld2")["cost_pen_ws_c"]
Objective=load("repos\\feasible_result_TRACT_$(nam).jld2")["Objective"]
time=load("repos\\feasible_result_TRACT_$(nam).jld2")["time"]

# We need to round the result for better understanding
PG=round.(Pg, digits=3)
QG=round.(Qg, digits=3)

LSH=round.(pen_lsh, digits=3 )
WS=round.(pen_ws, digits=3 )
# if empty_contin==0
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
         FL_inc=round.(p_fl_inc, digits=3)
         FL_dec=round.(p_fl_dec, digits=3)
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

          STR=round.((p_str), digits=3)
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
   xf[8]["A1"] = "Generation Cost"
   xf[8]["B1"] = round.(cost_gen, digits=3)
if  nFl!=0
   xf[8]["A2"] = "Flexibility Cost"
   if round.(cost_fl, digits=3)[1]>=0
   xf[8]["B2"] = round.(cost_fl, digits=3)
   else
   xf[8]["B2"] = 0
   end
end
if nStr_active!=0
   xf[8]["A3"] = "Storage Cost"
   if round.(cost_str, digits=3)[1]>= 0
   xf[8]["B3"] = round.(cost_str, digits=3)
   else
   xf[8]["B3"] = 0
   end
end
   xf[8]["A4"] = "Load curt. Cost"
   if round.(cost_pen_lsh, digits=3)[1]>=0
   xf[8]["B4"] = round.(cost_pen_lsh, digits=3)
   else
   xf[8]["B4"] = 0
   end

if !isempty(RES_bus)
   xf[8]["A5"] = "RES curt. Cost"
   if round.(cost_pen_ws, digits=3)[1]>=0
   xf[8]["B5"] = round.(cost_pen_ws, digits=3)
   else
   xf[8]["B5"] = 0
   end
end
   xf[8]["A6"] = "Total Cost"
    penlsh = round.( cost_pen_lsh , digits=3)[1]
    penlsh =[penlsh>=0 ? penlsh : 0][1]
    penws  = round.( cost_pen_ws, digits=3)[1]
    penws  =[penws>=0 ? penws : 0][1]
    str   =round.( cost_str , digits=3)[1]
    str  =[str>=0 ? str : 0][1]
    fl    =round.( cost_fl, digits=3)[1]
    fl =[fl>=0 ? fl : 0][1]
      xf[8]["B6"] = cost_gen+ penlsh + penws +str + fl

   xf[8]["A7"] = "Elapsed time"
   xf[8]["B7"] = time




end






while true
if    empty_contin==1
    break
end
# ==================================================================================
PG_C=round.(Pg_c, digits=3)
pgc_values=Dict{NTuple{4,Int64},Float64}()
for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nGens
    push!(pgc_values, (c,s,t,i)=>PG_C[c,s,t,i])
end

# keys_line_flow=collect(keys(line_flow_contin))
PGC_values=collect(values(pgc_values))

df1=DataFrame( keys(pgc_values),  )
df2=DataFrame( :values=>PGC_values)
df3=[df1 df2]


pdf=sort!(df3)
rename!(pdf,:1 => :Contingency_ID
         , :2 => :Scenarios
         , :3 => :time
         , :4 => :gen_units
         , :5 => :values
         )
for i in eachindex(pdf[:,:gen_units])
     pdf[i,:gen_units]=bus_data_gsheet[pdf[i,:gen_units]]
end
# XLSX.writetable("output_data\\$(nam)_post_contin.xlsx", "Active_power" => pdf)
# ==================================================================================
# ==================================================================================
QG_C=round.(Qg_c, digits=3)
qgc_values=Dict{NTuple{4,Int64},Float64}()
for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nGens
    push!(qgc_values, (c,s,t,i)=>QG_C[c,s,t,i])
end

# keys_line_flow=collect(keys(line_flow_contin))
QGC_values=collect(values(qgc_values))

df1=DataFrame( keys(qgc_values),  )
df2=DataFrame( :values=>QGC_values)
df3=[df1 df2]


qdf=sort!(df3)
rename!(qdf,:1 => :Contingency_ID
         , :2 => :Scenarios
         , :3 => :time
         , :4 => :gen_units
         , :5 => :values
         )

for i in eachindex(pdf[:,:gen_units])
              qdf[i,:gen_units]=bus_data_gsheet[qdf[i,:gen_units]]
end
 # ==================================================================================
 # ==================================================================================

FL_inc_c=round.(p_fl_inc_c, digits=3)
flinc_values=Dict{NTuple{4,Int64},Float64}()
# flincdf=DataFrame( Dict{NTuple{4,Int64},Float64}())
# if !isempty(nd_fl)
for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nFl
    push!(flinc_values, (c,s,t,i)=>FL_inc_c[c,s,t,i])
end

# keys_line_flow=collect(keys(line_flow_contin))
FLINC_values=collect(values(flinc_values))

flincdf1=DataFrame( keys(flinc_values),  )
flincdf2=DataFrame( :values=>FLINC_values)
flincdf3=[flincdf1 flincdf2]
flincdf=sort!(flincdf3)
rename!(flincdf,:1 => :Contingency_ID
         , :2 => :Scenarios
         , :3 => :time
         , :4 => :FL_units
         , :5 => :values
         )

         for i in eachindex(flincdf[:,:FL_units])
             if !isempty(nd_fl)
                      flincdf[i,:FL_units]=nd_fl[flincdf[i,:FL_units]]
                  end
         end
# end
# ==================================================================================
# ==================================================================================

FL_dec_c=round.(p_fl_dec_c, digits=3)
fldec_values=Dict{NTuple{4,Int64},Float64}()
# fldecdf=DataFrame( Dict{NTuple{4,Int64},Float64}())
# if !isempty(nd_fl)
for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nFl
    push!(fldec_values, (c,s,t,i)=>FL_dec_c[c,s,t,i])
end

# keys_line_flow=collect(keys(line_flow_contin))
FLDEC_values=collect(values(fldec_values))

fldecdf1=DataFrame( keys(fldec_values),  )
fldecdf2=DataFrame( :values=>FLDEC_values)
fldecdf3=[fldecdf1 fldecdf2]
fldecdf=sort!(fldecdf3)
rename!(fldecdf,:1 => :Contingency_ID
         , :2 => :Scenarios
         , :3 => :time
         , :4 => :FL_units
         , :5 => :values
         )
         for i in eachindex(fldecdf[:,:FL_units])
             if !isempty(nd_fl)
                      fldecdf[i,:FL_units]=nd_fl[fldecdf[i,:FL_units]]
                  end
         end
 # ==================================================================================
 # ==================================================================================

 STR=round.((p_str_c), digits=3)
 str_values=Dict{NTuple{4,Int64},Float64}()
 # strdf=DataFrame( Dict{NTuple{4,Int64},Float64}())
 # if !isempty(nd_fl)
 for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nStr_active
     push!(str_values, (c,s,t,i)=>STR[c,s,t,i])
 end

 # keys_line_flow=collect(keys(line_flow_contin))
 STR_values=collect(values(str_values))

strdf1=DataFrame( keys(str_values),  )
strdf2=DataFrame( :values=>STR_values)
strdf3=[strdf1 strdf2]
 strdf=sort!(strdf3)
 rename!(strdf,:1 => :Contingency_ID
          , :2 => :Scenarios
          , :3 => :time
          , :4 => :STR_units
          , :5 => :values
          )
          for i in eachindex(strdf[:,:STR_units])
              if nStr_active!=0
                       strdf[i,:STR_units]=nd_Str_active[strdf[i,:STR_units]]
                   end
          end
 # ==================================================================================
 # ==================================================================================
 LSH_C=round.((pen_lsh_c), digits=3)
 pen_lsh_values=Dict{NTuple{4,Int64},Float64}()
 # strdf=DataFrame( Dict{NTuple{4,Int64},Float64}())
 # if !isempty(nd_fl)
 for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nLoads
     push!(pen_lsh_values, (c,s,t,i)=>LSH_C[c,s,t,i])
 end

 # keys_line_flow=collect(keys(line_flow_contin))
 PEN_LSH_values=collect(values(pen_lsh_values))

 lshdf1=DataFrame( keys(pen_lsh_values),  )
 lshdf2=DataFrame( :values=>PEN_LSH_values)
 lshdf3=[lshdf1 lshdf2]
 lshdf=sort!(lshdf3)
 rename!(lshdf,:1 => :Contingency_ID
          , :2 => :Scenarios
          , :3 => :time
          , :4 => :nLoads
          , :5 => :values
          )
          for i in eachindex(lshdf[:,:nLoads])
              # if nStr_active!=0
                       lshdf[i,:nLoads]=bus_data_lsheet[lshdf[i,:nLoads]]
                   # end
          end

# ==================================================================================
# ==================================================================================
WS_C=round.((pen_ws_c), digits=3)
pen_ws_values=Dict{NTuple{4,Int64},Float64}()
# strdf=DataFrame( Dict{NTuple{4,Int64},Float64}())
# if !isempty(nd_fl)
for c in 1:nCont, s in 1:nSc, t in 1:nTP, i in 1:nRES
    push!(pen_ws_values, (c,s,t,i)=>WS_C[c,s,t,i])
end

# keys_line_flow=collect(keys(line_flow_contin))
PEN_WS_values=collect(values(pen_ws_values))

wsdf1=DataFrame( keys(pen_ws_values),  )
wsdf2=DataFrame( :values=>PEN_WS_values)
wsdf3=[wsdf1 wsdf2]
wsdf=sort!(wsdf3)
rename!(wsdf,:1 => :Contingency_ID
         , :2 => :Scenarios
         , :3 => :time
         , :4 => :nRES
         , :5 => :values
         )
         for i in eachindex(wsdf[:,:nRES])
             # if nStr_active!=0
                      wsdf[i,:nRES]=RES_bus[wsdf[i,:nRES]]
                  # end
         end




contin=DataFrame(raw_data[2:end, :], :auto)

rename!(contin,:1 => :Contin_Number
         , :2 => :From
         , :3 => :To
         )


# ==================================================================================

cost_names=Vector()
push!(cost_names, "Genereation Cost")
push!(cost_names, "Flexibility Cost")
push!(cost_names, "Storage Cost")
push!(cost_names, "Load curt. Cost")
push!(cost_names, "RES curt. Cost")
# push!(cost_names, "Post contingency costs")
push!(cost_names, "Flexibility Cost")
push!(cost_names, "Storage Cost")
push!(cost_names, "Load curt. Cost")
push!(cost_names, "RES curt. Cost")
push!(cost_names, "Total Cost")
push!(cost_names, "Elapsed time ")

cost_values=Vector()
push!(cost_values, round.(cost_gen, digits=3)[1])
penlsh = round.( cost_pen_lsh , digits=3)[1]
penlsh =[penlsh>=0 ? penlsh : 0][1]
penws  = round.( cost_pen_ws , digits=3)[1]
penws  =[penws>=0 ? penws : 0][1]
str   =round.( cost_str , digits=3)[1]
str  =[str>=0 ? str : 0][1]
fl    =round.( cost_fl , digits=3)[1]
fl =[fl>=0 ? fl : 0][1]

push!(cost_values,fl)
push!(cost_values,str)
push!(cost_values,penlsh)
push!(cost_values,penws)


penlshc = round.( cost_pen_lsh_c, digits=3)[1]
penlshc =[penlshc>=0 ? penlshc : 0][1]
penwsc  = round.( cost_pen_ws_c , digits=3)[1]
penwsc  =[penwsc>=0 ? penwsc : 0][1]
strc   =round.( cost_str_c , digits=3)[1]
strc  =[strc>=0 ? strc : 0][1]
flc    =round.(cost_fl_c , digits=3)[1]
flc =[flc>=0 ? flc : 0][1]

push!(cost_values,flc)
push!(cost_values,strc)
push!(cost_values,penlshc)
push!(cost_values,penwsc)



push!(cost_values, round.(cost_gen, digits=3)[1] + penlsh + penws + str + fl + penlshc + penwsc + strc + flc )
push!(cost_values, time)

costterms=[cost_names cost_values]
costdf=DataFrame(costterms, :auto)


rename!(costdf,:x1 => :Costs
         , :x2 => :Values
         )
#


XLSX.writetable("output_data\\$(nam)_$(yr)_$(sw)_$(wf)_post_contin.xlsx",
                 "Contin_map"     => contin,
                 "Active_power"   => pdf,
                 "Reactive_power" => qdf,
                 "FL_inc"         => flincdf,
                 "FL_dec"         => fldecdf,
                 "STR"            => strdf,
                 "Load_curtail"   => lshdf,
                 "RES_curtail"    => wsdf,
                 "Costs"          => costdf, overwrite=true)


break
end
end

if empty_contin==0
out_put_to_excel()
elseif empty_contin==1
    XLSX.openxlsx("output_data\\$(nam)_$(yr)_$(sw)_$(wf)_Normal.xlsx", mode="w") do xf
    # First of all set the first sheet name
        XLSX.rename!(xf[1], "Active_power")

    #xf[1] menas the first sheet
        xf[1]["A1"] = "Gen_nodes"
        xf[1]["A2", dim=1]= bus_data_gsheet

        Pg_vect = Vector()
        for t in 1:nTP
            push!(Pg_vect,zeros(size(bus_data_gsheet,1),1) )
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
            push!(Qg_vect,zeros(size(bus_data_gsheet,1),1) )
        end
        labels=["t$t" for t in 1:nTP]

        XLSX.writetable!(xf[2], Qg_vect, labels, anchor_cell=XLSX.CellRef("B1"))

    #--------------------------------------------------------------------

         XLSX.addsheet!(xf, "FL_inc")
         xf[3]["A1"] = "Flex_nodes"

         XLSX.addsheet!(xf, "FL_dec")
         xf[4]["A1"] = "Flex_nodes"
        labels=["t$t" for t in 1:nTP]
         # if nFl!=0
         #     FL_inc=round.(p_fl_inc, digits=3)
         #     FL_dec=round.(p_fl_dec, digits=3)
         # xf[3]["A2", dim=1]= nd_fl
         #    Fl_vect_inc = Vector()
         #      for t in 1:nTP
         #       push!(Fl_vect_inc,FL_inc[t,:] )
         #       end
         if nFl==0
        XLSX.writetable!(xf[3],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[4],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
    elseif nFl!=0
        xf[1]["A2", dim=1]= nd_fl
        xf[2]["A2", dim=1]= nd_fl
        Fl_vect_inc = Vector()
          for t in 1:nTP
           push!(Fl_vect_inc,zeros(1,nFl) )
          end
        XLSX.writetable!(xf[3],  Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[4],  Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))

    end
        # XLSX.writetable!(xf[3], Fl_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))

       #
       #  xf[4]["A2", dim=1]= nd_fl
       #     Fl_vect_dec = Vector()
       #       # for t in 1:nTP
       #       #  push!(Fl_vect_dec,FL_dec[t,:] )
       #       #  end
       # XLSX.writetable!(xf[4], Fl_vect_dec, labels, anchor_cell=XLSX.CellRef("B1"))
       #
       #    end
         #  XLSX.addsheet!(xf, "STR")
         #  xf[5]["A1"] = "STR_nodes"
         #
         #  if nStr_active!=0
         #
         #      STR=round.((p_str), digits=3)
         #      # STR=round.(STR, digits=3)
         #
         #
         #
         #
         #      xf[5]["A2", dim=1]= nd_Str_active
         #         STR_vect = Vector()
         #           for t in 1:nTP
         #            push!(STR_vect,STR[t,:] )
         #            end
         #     XLSX.writetable!(xf[5], STR_vect, labels, anchor_cell=XLSX.CellRef("B1"))
         # end
         #
         XLSX.addsheet!(xf, "ESS_CH_MW")
         xf[4]["A1"] = "Nodes"

        XLSX.addsheet!(xf, "ESS_DCH_MW")
        xf[5]["A1"] = "Nodes"

         XLSX.addsheet!(xf, "ESS_SOC")
            xf[6]["A1"] = "Nodes"
         if nStr==0
        XLSX.writetable!(xf[5],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[6],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
        XLSX.writetable!(xf[7],  zeros(1,nTP), labels, anchor_cell=XLSX.CellRef("B1"))
    elseif nStr!=0
        xf[5]["A2", dim=1]= nd_Str_active
        xf[6]["A2", dim=1]= nd_Str_active
        xf[7]["A2", dim=1]= nd_Str_active

        st_vect_inc = Vector()
          for t in 1:nTP
           push!(st_vect_inc,zeros(1,nStr) )
          end
          XLSX.writetable!(xf[5],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
          XLSX.writetable!(xf[6],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))
          XLSX.writetable!(xf[7],  st_vect_inc, labels, anchor_cell=XLSX.CellRef("B1"))

    end


         XLSX.addsheet!(xf, "Load_curtailment")
         xf[8]["A1"] = "Load_nodes"
         xf[8]["A2", dim=1]= bus_data_lsheet
            lsh_vect = Vector()
              for t in 1:nTP
               push!(lsh_vect,zeros(size(bus_data_lsheet,1),1) )
               end
        XLSX.writetable!(xf[8], lsh_vect, labels, anchor_cell=XLSX.CellRef("B1"))

    # if !isempty(RES_bus)
        XLSX.addsheet!(xf, "RES_curtailment")
        xf[9]["A1"] = "RES_nodes"
        xf[9]["A2", dim=1]= RES_bus
           ws_vect = Vector()
             for t in 1:nTP
              push!(ws_vect,zeros(size(RES_bus,1),1) )
              end
       XLSX.writetable!(xf[9], ws_vect, labels, anchor_cell=XLSX.CellRef("B1"))

    # end
       XLSX.addsheet!(xf, "COSTS")
       xf[10]["A1"] = "Generation Cost"
       xf[10]["B1"] = 0
    if  nFl!=0
       xf[10]["A2"] = "Flexibility Cost"
       # if round.(cost_fl, digits=3)[1]>=0
       # xf[8]["B2"] = round.(cost_fl, digits=3)
       # else
       xf[10]["B2"] = 0
       # end
    end
    if nStr_active!=0
       xf[10]["A3"] = "Storage Cost"
       # if round.(cost_str, digits=3)[1]>= 0
       # xf[8]["B3"] = round.(cost_str, digits=3)
       # else
       xf[10]["B3"] = 0
       # end
    end
       xf[10]["A4"] = "Load curt. Cost"
       # if round.(cost_pen_lsh, digits=3)[1]>=0
       # xf[8]["B4"] = round.(cost_pen_lsh, digits=3)
       # else
       xf[10]["B4"] = 0
       # end

    if !isempty(RES_bus)
       xf[10]["A5"] = "RES curt. Cost"
       # if round.(cost_pen_ws, digits=3)[1]>=0
       # xf[8]["B5"] = 0
       # else
       xf[10]["B5"] = 0
       # end
    end
       xf[10]["A6"] = "Total Cost"
        # penlsh = round.( cost_pen_lsh , digits=3)[1]
        # penlsh =[penlsh>=0 ? penlsh : 0][1]
        # penws  = round.( cost_pen_ws, digits=3)[1]
        # penws  =[penws>=0 ? penws : 0][1]
        # str   =round.( cost_str , digits=3)[1]
        # str  =[str>=0 ? str : 0][1]
        # fl    =round.( cost_fl, digits=3)[1]
        # fl =[fl>=0 ? fl : 0][1]
          # xf[8]["B6"] = cost_gen+ penlsh + penws +str + fl
       xf[10]["B6"]  = 0
       xf[10]["A7"] = "Elapsed time"
       xf[10]["B7"] = 0




    end




# end

end
