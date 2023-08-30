# while true
    println(" For Contin Filtering==================>type =1")
    println(" For AC-OPF============================>type =2")
    println(" For AC-SCOPF==========================>type =3")
    println(" For Tractable S-MP-AC-SCOPF===========>type =4")
    println(" For Security Assessment ==============>type =5")
    println(" For Power Flow =======================>type =6")
    println(" Which problem to solve?")

    problem = readline()
    problem = parse(Int64, problem)
    println("The selected problem is:")
    if      problem==1
        show("Contingency Filtering")
    elseif    problem==2
        show("AC_OPF")
    elseif problem==3
        show("AC_SCOPF")
    elseif problem==4
        show("Tractable S-MP-AC-SCOPF")
    elseif problem==5
        show("Security Assessment")
    elseif problem==6
        show("Power Flow")
    # elseif problem==0
    #     break
    end
println("")
println("Please select the Data Set:")
# println("Nordic32===>type =1")
# println("PT_Tx_2020=>type =1")
println("Croatian=====>type= 1")
# println("HR_Tx_02_2020_new_NW_Croatia_WP4=>type= 2")
# println("HR_Tx_03_2020_new_Zagreb=========>type= 3")
# println("Transmission_Network_UK_v2=======>type= 4")
println("UK===========>type= 2")
println("Portuguese===>type= 3")
println("Nordic32=====>type =4")
# println("PT_Tx_2030_Active================>type= 7")
# println("PT_Tx_2030_Slow==================>type= 8")
# println("PT_Tx_2040_Active================>type= 9")
# println("PT_Tx_2040_Slow==================>type= 10")
# println("PT_Tx_2050_Active================>type= 11")
# println("PT_Tx_2050_Slow==================>type= 12")
# println("Nordic32=========================>type= 13")
# println("Portuguese=======================>type= 14")
println("Which Data SET?")
test_case = readline()
test_case = parse(Int64, test_case)
println("The selected Data Set is:")
global nam
if test_case==1
    show("Croatian")
    nam ="HR"
    # load_correction=1
# elseif test_case==2
#     show("HR_Tx_02_2020_new_NW_Croatia_WP4")
#     nam ="HR_Tx_02_2020_new_NW_Croatia_WP4"
    # load_correction=1
# elseif test_case==3
#     show("HR_Tx_03_2020_new_Zagreb")
#     nam ="HR_Tx_03_2020_new_Zagreb"
    # load_correction=1
# elseif test_case==4
#     show("Transmission_Network_UK_v2")
#     nam ="Transmission_Network_UK_v2"
    # load_correction=1
elseif test_case==2
    show("UK")
    nam ="UK"
    # load_correction=1
elseif test_case==3
    show("Portuguese")
    nam = "PT"
    # load_correction=0.01
# elseif test_case==7
#     show("PT_Tx_2030_Active")
#     nam = "PT_Tx_2030_Active"
    # load_correction=0.01
# elseif test_case==8
#     show("PT_Tx_2030_Slow")
#     nam = "PT_Tx_2030_Slow"
    # load_correction=0.01
# elseif test_case==9
#     show("PT_Tx_2040_Active")
#     nam = "PT_Tx_2040_Active"
    # load_correction=0.01
# elseif test_case==10
#     show("PT_Tx_2040_Slow")
#     nam = "PT_Tx_2040_Slow"
    # load_correction=0.01
# elseif test_case==11
#     show("PT_Tx_2050_Active")
#     nam = "PT_Tx_2050_Active"
    # load_correction=0.01
# elseif test_case==12
#     show("PT_Tx_2050_Slow")
#     nam = "PT_Tx_2050_Slow"
    # load_correction=0.01
elseif test_case==4
    show("Nordic32")
    nam = "Nordic32"
    # load_correction=1
# elseif test_case==14
#     show("Portuguese")
#     nam = "Portuguese"
    # load_correction=1
# elseif test_case==0
#     break
end

 filename =      "input_data/$(nam).ods"
 filename_prof = "input_data/$(nam)_PROF.ods"
 println("")
 println("")
 println("")
 println("Which load profile? Summer=>1, Winter=2")
  sw = readline()
 sw = parse(Int64, sw)
 println("The selected load profile is:")
 if      sw==1
     show("Summer")
     sw="SU"
 elseif sw==2
     show("Winter")
     sw="WT"
 else
     show("Your selection is wrong. ")
     println("Once again?")
     sw = readline()
     sw = parse(Int64, sw)
 end






println("")

println("Which yr?")
 yr = readline()
yr = parse(Int64, yr)
println("The selected yr is:")
if      yr==2020
    show("2020")
elseif yr== 2030
    show("2030")
elseif yr== 2040
    show("2040")
elseif yr== 2050
    show("2050")
# elseif yr==0
#     break
else
    show("Your selection is wrong. ")
    println("Once again?")
    yr = readline()
    yr = parse(Int64, yr)
end
println("")
println("With -->'1' or without -->'2' flexibility?")
floption = readline()
floption = parse(Int64, floption)
global flo
if floption==2
    show("Your selection is WITHOUT flexibility ")
    flo=0
    # break
elseif floption==1
    show("Your selection is WITH flexibility ")
    flo=1
#     break
# elseif floption==0
#     break
else

    show("Your selection is wrong. ")
    println("Once again?")
    floption = readline()
    floption = parse(Int64, flo)
end
# end
