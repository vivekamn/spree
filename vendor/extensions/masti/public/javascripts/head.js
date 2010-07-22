
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}


	 function submitForm_on_enter(e,formName)
                {
                var keynum;
                if(window.event) // IE
                	{
                	keynum = e.keyCode;
                	}
                else if(e.which) // Netscape/Firefox/Opera
                	{
                	keynum = e.which;
                	}
                if(keynum == 13){
                    submitForm(formName);                    
                }
            }
			
	function email_validate_head(){
		var EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i;
		var flag_em = true;
		var email_name = document.getElementById('deals_notification_email').value;
		var error_msg_div = document.getElementById('error_email');
		if (email_name != ''){
		if (email_name.length != 0){
		 email_my = new String(email_name);
		 email_my=email_my.trim();
		 email_value = EMAIL_REGEX.test(email_my); 
		 if(email_value != 1){
			error_msg_div.innerHTML = "Please enter valid E-mail";
			flag_em=false;	
		 }
		}
		else{
			error_msg_div.innerHTML = "Please enter valid E-mail";
			flag_em=false;	
		}
	}else{
		error_msg_div.innerHTML = "Please enter valid E-mail";
		flag_em=false;
	}
	
	return flag_em;
	
	}

