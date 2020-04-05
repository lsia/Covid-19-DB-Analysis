// Create index before loading data
call db.index.fulltext.createNodeIndex("name",["location","airplane","train", "metro", "long_distance", "bus", "rental", "ship", "place"],["name"]);


WITH "https://2019ncov.nosugartech.com/data.json" AS url 
CALL apoc.load.json(url) YIELD value
UNWIND value.data AS item 
// Create / merge Locaton and Vehicle nodes
with item,
     ['airplane', 'train', 'subway', 'long_distance ','bus', 'rental', 'ship', 'place'] [item.t_type-1] as type,
     ['flight', 'car_number', 'line_number', 'license_plate', 'license_plate', 'license_plate', 'ship_time', 'name'][item.t_type-1] as no_name 
call apoc.merge.node([type], {id:item.id}, 
    {
        name: item.t_no + case when item.t_no_sub = '' then '' else '' + item.t_no_sub end, 
        type: type, 
        date: item.t_date,  
        start_time: item.t_start, 
        end_time: item.t_end, 
        travel_type: type, 
        travel_description: item.t_memo, 
        car: item.t_no_sub, 
        departure_station: item.t_pos_start, 
        arrival_station: item.t_pos_end, 
        clue_source: item.source, 
        clues_person: item.who, 
        updated: item.updated_at
     },
    {}) yield node 
// Create start node
with item, node where item.t_pos_start<>''
merge (p1:location {name:item.t_pos_start}) 
// Create end node
with item, node, p1 where item.t_pos_end<>'' and  item.t_pos_start<>item.t_pos_end 
merge (p2:location {name:item.t_pos_end}) 
// Create relationships to connect Start and End nodes
merge (p1)-[r1:departure]->(node)-[r2:arrival]->(p2)
return count(r2);