//document.addEventListener("DOMContentLoaded", function(event) {
$(document).on('ready companies.show:change', function() {
var pocetni = gon.companies;
var povezani = gon.povezani;
var nodes = [];

for (var i = 0; i < pocetni.length; i++) {
    nodes.push({
        data: {
            id: pocetni[i],
            name:pocetni[i],
            size: 5
        }
    });
}
var cy = cytoscape({ 
  
      elements: nodes,
      container: document.getElementById('cy'),
      style: [{ selector: 'node', style: { 'background-color': 'green', 'label': 'data(id)', 'border-style': 'double' } }]
});

//var novi = cytoscape({
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
