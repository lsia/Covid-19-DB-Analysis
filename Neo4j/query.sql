
// Set the node display attribute 
with [ 
        {color: '#FFE081', `border-color`: '#9AA1AC',` text-color-internal`: '#FFFFFF'} , 
        {color: '#C990C0', `border-color`: '#b261a5',` text-color-internal`: '#FFFFFF'}, 
        {color: '#F79767', `border-color`: '#f36924 ', `text-color-internal`:' #FFFFFF '},
        { color: '#57C7E3', `border-color`: '#23b3d7', `text-color-internal`: '#FFFFFF'},
        { color: '#F16667', `border-color`: '#eb2728', `text-color-internal`: '#FFFFFF'},
        { color: '#D9C8AE', `border-color`: '#c0a378', `text-color-internal`: '#604A0E'},
        { color: '#8DCC93', `border-color`: '#5db665', `text-color-internal`: '#604A0E'},
        { color: '#ECB5C9', `border-color`: '#da7298', `text-color-internal`: '#604A0E'},
        { color: '#4C8EDA', `border-color`: '#2870c2', `text-color-internal`: '#FFFFFF'},
        { color: '#FFC454', `border-color`: '#d7a013', `text-color-internal`: '#604A0E'},
        { color: '#DA7194', `border-color`: '#cc3c6c', `text-color-internal`: '#FFFFFF'},
        { color: '#569480', `border-color`: '#447666', `text-color-internal`: '#FFFFFF'}
    ]
    as nodeSettings 
MATCH (n:location)
with nodeSettings, n, apoc.node.degree(n, '<') as cnt_in, apoc.node.degree(n, '>') as cnt_out 
with nodeSettings, n, cnt_in, cnt_out,  
     case when cnt_out=0 then 11 when cnt_out<5 then 3 else 10 end as index 
set n.diameter=80+cnt_out*100/500, n+=nodeSettings[index], 
    n.outgoing=cnt_out, 
    n.incoming=cnt_in, 
    n.caption=n.name+'('+cnt_in+","+cnt_out+')'