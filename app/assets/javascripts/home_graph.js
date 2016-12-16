//document.addEventListener("DOMContentLoaded", function(event) {
$(document).on('ready companies.show:change', function() {
var pocetni = gon.companies;
var povezani = gon.povezani;
var kombinacije = gon.kombinacije;
var nodes = [];

for (var i = 0; i < povezani.length; i++) {
    nodes.push({
        data: {
            id: povezani[i],
            name:povezani[i],
            size: 5
        }
    });
}
for (var i = 0; i < kombinacije.length; i++) {
    nodes.push({
        data: {
            id: String(kombinacije[i][0]) + String(kombinacije[i][1]) + i,
            source: kombinacije[i][0],
            target: kombinacije[i][1]
        }
    });
}

var cy = cytoscape({ 
  
      elements: nodes,
      container: document.getElementById('cy'),
      style: [{ selector: 'node', style: { 'background-color': 'lightblue', 'label': 'data(id)', 'border-style': 'double' } }]
});

//var novi = cytoscape({ ,
//    container: document.getElementById('cy')
//});
//novi.add(aaa)
//cy = function() {
//cytoscape({
//  container: document.getElementById('cy'),
//  elements: 
//  [
  // nodes
    // { data: { id: 'a' } },
    // { data: { id: 'b' } },
    // { data: { id: 'c' } },
    // { data: { id: 'd' } },
    // { data: { id: 'e' } },
    // { data: { id: 'f' } },
    // { data: { id: 'ee' } },
    // { data: { id: 'ff' } },
//    {nodes: gon.companies},
  // edges
    // { data: { id: 'ab', source: 'a', target: 'b'} },
    // { data: { id: 'cd', source: 'c', target: 'd'} },
    // { data: { id: 'ef', source: 'e', target: 'f'} },
    // { data: { id: 'ac', source: 'a', target: 'd'} },
    // { data: { id: 'mm', source: 'e', target: 'e'} },
    // { data: { id: 'be', source: 'b', target: 'e'} }
//  ],
  
//  style: 
//  [
//    {
//      selector: 'edge', style: { 'line-color': 'yellow' },
//      selector: 'node', style: { 'background-color': 'green', 'label': 'data(id)', 'border-style': 'double' }
//    }
//  ],
//  layout: {
//name: 'random'
//					},      
//})};

//$(document).ready(cy);
//$(document).on('page:load', cy);

//console.log(gon.companies);

});
