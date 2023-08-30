old_data=deepcopy(data)
missing_busses=[]
for i in 1:size(data[:,1],1)
idx=findall(x->x==i,data[:,1])
if isempty(idx)
    push!(missing_busses, i)
end
 end

if !isempty(missing_busses)
for i in eachindex(missing_busses)
   for    j in i:size(data[:,1],1)
    data[j,1]=j

end
end

map=[data[:,1] old_data[:,1]]
#correcting bus sheet
ods_write("input_data\\$(nam).ods",Dict(("Buses",2,1)=>[map[:,1]  data[:,2]]))


data      = convert(Array{Float64}, data)
data_cont = zeros(size(fields,1))               # data_cont = Data Container
nBus      = Int64(size(data,1))
global array_bus = Array{Bus}(undef,nBus,1)

array_bus = data_reader(array_bus,nBus,fields,header,data,data_cont,Bus)
rheader_buses = header    # Exporting raw header of buses sheet
rdata_buses = deepcopy(data)        # Exporting raw data of buses sheet
raw_data = nothing
header = nothing
data = nothing
#correcting line sheet
line_data = ods_readall(filename;sheetsNames=["Lines"],innerType="Matrix")
line_data = line_data["Lines"]
line_data = line_data[2:end,:]
line_map=line_data[:,1:2]
old_line=deepcopy(line_map)

for i in 1:length(line_map[:,1])

    old_line[i,:]=replace!(old_line[i,:] ,old_line[i,1]=> map[findall(x->x==line_map[i,1], map[:,2])[1],1])
    old_line[i,:]=replace!(old_line[i,:] ,old_line[i,2]=> map[findall(x->x==line_map[i,2], map[:,2])[1],1])

end
ods_write("input_data\\$(nam).ods",Dict(("Lines",2,1)=>old_line))
line_data=nothing
#correcting generator sheets
ggen_data = ods_readall(filename;sheetsNames=["Gens"],innerType="Matrix")
ggen_data = ggen_data["Gens"]
ggen_data = ggen_data[2:end,:]
gen_map=ggen_data[:,1]
old_gen=deepcopy(gen_map)
for i in 1:length(gen_map[:,1])
    # idx_gen=findall(x->x==gen_map[i,1], map[:,2])
    # if !isempty(idx_gen)
    # replace!(old_gen ,old_gen[i,1]=> map[idx_gen[1],1])
    # end
    old_gen[i,:]=replace!(old_gen[i,:] ,old_gen[i,1]=> map[findall(x->x==gen_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam).ods",Dict(("Gens",2,1)=>[old_gen ggen_data[:,2]]))
ggen_data=nothing
#correcting loads sheet
loadd_data = ods_readall(filename;sheetsNames=["Loads"],innerType="Matrix")
loadd_data = loadd_data["Loads"]
loadd_data = loadd_data[2:end,:]
load_map=loadd_data[:,1]
old_load=deepcopy(load_map)
for i in 1:length(load_map[:,1])
    # idx_l=findall(x->x==load_map[i,1], map[:,2])
    # if !isempty(idx_l)
    # replace!(old_load ,old_load[i,1]=> map[idx_l[1],1])
    # end
    old_load[i,:]=replace!(old_load[i,:] ,old_load[i,1]=> map[findall(x->x==load_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam).ods",Dict(("Loads",2,1)=>[old_load loadd_data[:,2]]))
loadd_data=nothing
#correcting transformers
t_data = ods_readall(filename;sheetsNames=["Transformers"],innerType="Matrix")
t_data = t_data["Transformers"]
t_data = t_data[2:end,:]
t_map=t_data[:,1:2]
old_t=deepcopy(t_map)

for i in 1:length(t_map[:,1])
    # idx_t1=findall(x->x==t_map[i,1], map[:,2])
    # if !isempty(idx_t1)
    # replace!(old_t ,old_t[i,1]=> map[idx_t1[1],1])
    # end
    old_t[i,:]=replace!(old_t[i,:] ,old_t[i,1]=> map[findall(x->x==t_map[i,1], map[:,2])[1],1])
    old_t[i,:]=replace!(old_t[i,:] ,old_t[i,2]=> map[findall(x->x==t_map[i,2], map[:,2])[1],1])
    # idx_t2=findall(x->x==t_map[i,2], map[:,2])
    # if !isempty(idx_t2)
    # replace!(old_t ,old_t[i,2]=> map[idx_t2[1],1])
    # end
end
ods_write("input_data\\$(nam).ods",Dict(("Transformers",2,1)=>old_t))
t_data=nothing
#correcting shunts
shunt_data = ods_readall(filename;sheetsNames=["shunts"],innerType="Matrix")
shunt_data = shunt_data["shunts"]
shunt_data = shunt_data[2:end,:]
shunt_map=shunt_data[:,1]
old_sh=deepcopy(shunt_map)
for i in 1:length(shunt_map[:,1])
    # idx_sh=findall(x->x==shunt_map[i,1], map[:,2])
    # if !isempty(idx_sh)
    # replace!(old_sh ,old_sh[i,1]=> map[idx_sh[1],1])
    # end
    old_sh[i,:]=replace!(old_sh[i,:] ,old_sh[i,1]=> map[findall(x->x==shunt_map[i,1], map[:,2])[1],1])

end
ods_write("input_data\\$(nam).ods",Dict(("shunts",2,1)=>[old_sh shunt_data[:,2]]))
shunt_data=nothing

include("PROF_correction.jl")

else
    data      = convert(Array{Float64}, data)
    data_cont = zeros(size(fields,1))               # data_cont = Data Container
    nBus      = Int64(size(data,1))
    global array_bus = Array{Bus}(undef,nBus,1)

    array_bus = data_reader(array_bus,nBus,fields,header,data,data_cont,Bus)
    rheader_buses = header    # Exporting raw header of buses sheet
    rdata_buses = deepcopy(data)        # Exporting raw data of buses sheet
    raw_data = nothing
    header = nothing
    data = nothing
end
