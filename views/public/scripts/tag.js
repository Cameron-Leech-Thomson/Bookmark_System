/*********************  Functions  ******************/
function searchTag(){
    var input = document.getElementById("input");
    var filter = input.value.toUpperCase();
    var ul = document.getElementById("tagsList");
    var lis = ul.getElementsByTagName("li");
    var exactMatch = false;

    for ( var li of lis ){
	var content = li.textContent;
	if (content.indexOf("Create ") == 0){
	    li.remove();
	} else{
	    var hash = genRandom(li.firstChild.firstChild.nodeValue.hashCode())*60 + 180;
	    li.childNodes[0].style.backgroundColor = "rgb(" + hash + "," + hash + "," + hash + ")";
	    if (content.toUpperCase().indexOf(filter) > -1){ 
		li.style.display = "block"; 
		if (content.toUpperCase() === filter){
		    exactMatch = true;
		}
	    }else{
		li.style.display = "none";
	    }
	}
    }

    if ( !exactMatch && input.value.length != 0 ){
	var create = document.createElement("li");
	var createText = document.createTextNode("Create ");
	var createDiv = document.createElement("div");
	var divText = document.createTextNode(input.value);
	createDiv.appendChild(divText);
	createDiv.style.backgroundColor = createColor;
	create.appendChild(createText);
	create.appendChild(createDiv);
	create.addEventListener("click",function(){ createTag(input.value); } );
	ul.insertBefore(create,ul.firstChild);
	create.style.display = "block";
    }
}

function genRandom(seed){
    var x = Math.sin(seed++) * 10000;
    return x - Math.floor(x);
}

function addTag(id,name){
    var tagArea = document.getElementById("tagArea");
    var tags = document.getElementById("tags");
    var tagDiv = document.createElement("div");
    var input = document.getElementById("input");

    // Prevent duplicate
    var createdTags = tagArea.getElementsByTagName("div");
    for (var tag of createdTags){
	if (name === tag.textContent) {
	    return; 
	}
    }

    // Create the tag to be displayed
    tagDiv.appendChild(document.createTextNode(name)); // create a div containing tag
    var hash = genRandom(name.hashCode())*60 + 180;
    tagDiv.style.backgroundColor = "rgb(" + hash + "," + hash + "," + hash + ")";
    tagArea.appendChild(tagDiv);  // Display tag in the tag area
    input.value = ""; // Clear the input

    // set the value in the form
    if (tags.value === "") tags.value = id;
    else tags.value += "," + id;
}

function createTag(name){
    var tagArea = document.getElementById("tagArea");
    var tagDiv = document.createElement("div");
    var input = document.getElementById("input");
    var createTags = document.getElementById("createTags");

    // Prevent duplicate
    var createdTags = tagArea.getElementsByTagName("div");
    for (var tag of createdTags){
	if (name === tag.textContent) {
	    return; 
	}
    }

    // Create the tag to be displayed
    tagDiv.appendChild(document.createTextNode(name)); // create a div containing tag
    var hash = genRandom(name.hashCode())*60 + 180;
    tagDiv.style.backgroundColor = "rgb(" + hash + "," + hash + "," + hash + ")";
    tagArea.appendChild(tagDiv);  // Display tag in the tag area
    input.value = ""; // Clear the input

    // set the value in the form
    if (createTags.value === "") createTags.value = name;
    else createTags.value += "," + name;
}

function applyRandomColor(){
    var tags = document.getElementsByClassName()
}
/****************  Main  *************/
console.log("At least js is working! Yay!");
// generate random color for create new tag
var createColor = "rgb(" + (180 +Math.random()*60) + "," + (Math.random()*60+180) + "," + (Math.random()*60+180) + ")";

// generate hash for string
Object.defineProperty(String.prototype, 'hashCode', {
    value: function() {
	var hash = 0, i, chr;
	for (i = 0; i < this.length; i++) {
	    chr   = this.charCodeAt(i);
	    hash  = ((hash << 5) - hash) + chr;
	    hash |= 0; // Convert to 32bit integer
	}
	return hash;
    }
});

var tags = document.getElementsByClassName("tags");

