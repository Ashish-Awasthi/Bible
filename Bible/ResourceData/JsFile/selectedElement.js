var selectedId = "";


$(document).ready(function(){
                  $('a').click(function(){
                               selectedId = $(this).attr('id');
                               })
                  });