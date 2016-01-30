$(window).load(function(){
	getInput();
});

function getInput() {
	var nodes = document.getElementById('form-create-contact').childNodes;
	//parse through form
	for(i=0; i<nodes.length; i+=1) {
		//filter input elements
		if (nodes[i].nodeType == 1 && nodes[i].tagName.toLowerCase() == "input") {

			console.log(nodes[i].value);
		}
	}
}