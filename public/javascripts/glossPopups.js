$(document).ready(function(){
 $("a.term-link").hover(function(event){
           var offset = $(this).offset();
           if(offset.left < 250){
               $(this).next("em").css({'left': '125%','right':'auto', 'display':'block'});
             }
           if(offset.top < 300){
               $(this).next("em").css({'top': '10px', 'display':'block'});
           }

            $(this).next("em").animate({opacity: "show", top: "-75"}, "fast");
          }, function() {
             $(this).next("em").animate({opacity: "hide", top: "-75"}, 100);
             setTimeout(function(){
               $(this).next("em").css({'right': '125%', 'left': 'auto'});
             },101);

	});
});/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


