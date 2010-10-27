/**
 * @author ramanavel
 */
var flashvars = {
		};
		var params = {
		};
		var attributes = {
		    wmode: "transparent"
		};
	    swfobject.embedSWF("/takeover/media/webbys.swf", "myContent", "400", "300", "9.0.0", flashvars, params, attributes);
	    jQuery(document).ready(function(){
	        jQuery("#close-flash").hide();
	        jQuery("#close-flash").delay(6000).show("slow");
	        
	        jQuery("#close-flash").click(function(event){
	            event.preventDefault();
	            jQuery("#bottom").hide("slide", { direction: "down" }, 1000);
	        });
	        
	        positionFooter(); 
			function positionFooter(){
				jQuery("#bottom").css({bottom:0,position: "absolute",top:(jQuery(window).scrollTop()+jQuery(window).height()-jQuery("#bottom").height())+"px"})	
			}
		 
			jQuery(window)
				.scroll(positionFooter)
				.resize(positionFooter)
			
			jQuery("#mycarousel").jcarousel({
			    auto:3,
			    buttonNextHTML: null,
			    buttonPrevHTML: null,
			    scroll: 1,
			    wrap: "both",
			    itemVisibleInCallback: {
			      onBeforeAnimation: carousel_before
			    },
			    initCallback: mycarousel_initCallback
			});
			    });
	    
	    function silver_carousel_before(carousel){
	        jQuery('.silver-light .jcarousel-control a').removeClass('carousel-on');
	        jQuery('.silver-light .jcarousel-control a').each(function(){
	            if(jQuery(this).text()==carousel.first){
	                jQuery(this).addClass('carousel-on');
	            }
	        });
	        
	    }
	    
	    function carousel_before(carousel){
	        jQuery('.jcarousel-skin-tango .jcarousel-control a').removeClass('carousel-on');
	        jQuery('.jcarousel-skin-tango .jcarousel-control a').each(function(){
	            if(jQuery(this).text()==carousel.first){
	                jQuery(this).addClass('carousel-on');
	            }
	        });
	    }
	    
	    
	    function mycarousel_initCallback(carousel) {
	        jQuery('.jcarousel-skin-tango .jcarousel-control a').bind('click', function() {
	            carousel.scroll(jQuery.jcarousel.intval(jQuery(this).text()));
	            jQuery('.jcarousel-skin-tango .jcarousel-control a').removeClass('carousel-on');
	            jQuery(this).addClass('carousel-on');
	            carousel.startAuto(0);
	            return false;
	        });
	    
	        jQuery('.jcarousel-skin-tango .jcarousel-scroll select').bind('change', function() {
	            carousel.options.scroll = jQuery.jcarousel.intval(this.options[this.selectedIndex].value);
	            return false;
	        });
	    
	    };
	    
	    function silvercarousel_initCallback(carousel) {
	        jQuery('.silver-light .jcarousel-control a').bind('click', function() {
	            carousel.scroll(jQuery.jcarousel.intval(jQuery(this).text()));
	            jQuery('.silver-light .jcarousel-control a').removeClass('carousel-on');
	            jQuery(this).addClass('carousel-on');
	            carousel.startAuto(0);
	            return false;
	        });
	    
	        jQuery('.silver-light .jcarousel-scroll select').bind('change', function() {
	            carousel.options.scroll = jQuery.jcarousel.intval(this.options[this.selectedIndex].value);
	            return false;
	        });
	    
	    };
		
		
		
jQuery(document).ready(function(){

	jQuery("ul.subnav").parent().append("<span></span>"); //Only shows drop down trigger when js is enabled - Adds empty span tag after ul.subnav
	
	jQuery("ul.topnav li a").hover(function() { //When trigger is clicked...
		
		//Following events are applied to the subnav itself (moving subnav up and down)
		jQuery(this).parent().find("ul.subnav").slideDown('fast').show(); //Drop down the subnav on click

		jQuery(this).parent().hover(function() {
		}, function(){	
			jQuery(this).parent().find("ul.subnav").slideUp('slow'); //When the mouse hovers out of the subnav, move it back up
		});

		//Following events are applied to the trigger (Hover events for the trigger)
		}).hover(function() { 
			jQuery(this).addClass("subhover"); //On hover over, add class "subhover"
		}, function(){	//On Hover Out
			jQuery(this).removeClass("subhover"); //On hover out, remove class "subhover"
	});

});


