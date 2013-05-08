var selectedId = "";
//var bgspanColor= "green";



$(document).ready(function(){
                 
        $('a').click(function(){
        selectedId = $(this).attr('id');
            })
});
                   
function addHighlight(id,color)
{
    var spanCol = document.querySelectorAll(".american_typewriter");
    [].forEach.call(spanCol,function(item,index){
           item.style.backgroundColor = "transparent";
    });
    var typeWriterCollection = document.getElementById(id).querySelectorAll(".american_typewriter");
    [].forEach.call(typeWriterCollection,function(item2,index2){
                    //item2.style.backgroundColor = color;
                    item2.style.color = color;
    })
    //elem.style.backgroundColor = color;
    //id.style.classList.add("color2");
}

function removeHighlight(id,color){
    
    var spanCol = document.querySelectorAll(".american_typewriter");
    [].forEach.call(spanCol,function(item,index){
                    item.style.backgroundColor = "transparent";
                    });
    var typeWriterCollection = document.getElementById(id).querySelectorAll(".american_typewriter");
    [].forEach.call(typeWriterCollection,function(item2,index2){
                    //item2.style.backgroundColor = color;
                    item2.style.color = color;
                    })
}