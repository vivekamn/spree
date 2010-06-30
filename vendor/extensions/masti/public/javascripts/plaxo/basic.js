 function inherits(child,parent){if(typeof parent.prototype=='function'){inherits(child,parent.prototype)}for(var method in parent.prototype){if(method=='prototype'){continue}child[method]=parent.prototype[method]}};function sprintf(){if(!arguments||arguments.length<1||!RegExp){return}var str=arguments[0];var re=/([^%]*)%('.|0|\x20)?(-)?(\d+)?(\.\d+)?(%|b|c|d|u|f|o|s|x|X)(.*)/; //'
	var a = b = [], numSubstitutions = 0, numMatches = 0;
	while (a = re.exec(str)) {
		var leftpart = a[1], pPad = a[2], pJustify = a[3], pMinLength = a[4];
		var pPrecision = a[5], pType = a[6], rightPart = a[7];

		
		numMatches++;
		if (pType == '%') {
			subst = '%';
		} else {
			numSubstitutions++;
			if (numSubstitutions >= arguments.length) {
				alert('Error! Not enough function arguments (' + (arguments.length - 1) + ', excluding the string)\nfor the number of substitution parameters in string (' + numSubstitutions + ' so far).');
			}
			var param = arguments[numSubstitutions];
			var pad = '';
			if (pPad && pPad.substr(0,1) == "'") pad = leftpart.substr(1,1);
			else if (pPad) pad = pPad;
			var justifyRight = true;
			if (pJustify && pJustify === "-") justifyRight = false;
			var minLength = -1;
			if (pMinLength) minLength = parseInt(pMinLength);
			var precision = -1;
			if (pPrecision && pType == 'f') precision = parseInt(pPrecision.substring(1));
			var subst = param;
			if (pType == 'b') subst = parseInt(param).toString(2);
			else if (pType == 'c') subst = String.fromCharCode(parseInt(param));
			else if (pType == 'd') subst = parseInt(param) ? parseInt(param) : 0;
			else if (pType == 'u') subst = Math.abs(param);
			else if (pType == 'f') subst = (precision > -1) ? Math.round(parseFloat(param) * Math.pow(10, precision)) / Math.pow(10,precision):parseFloat(param);else if(pType=='o')subst=parseInt(param).toString(8);else if(pType=='s')subst=param;else if(pType=='x')subst=(''+parseInt(param).toString(16)).toLowerCase();else if(pType=='X')subst=(''+parseInt(param).toString(16)).toUpperCase()}str=leftpart+subst+rightPart}return str};function popup(url,title,width,height){var numArgs=arguments.length;var ht;var windowObj;var windowParams=(numArgs>4)?arguments[4]:'statusbar=no,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,top=0';var isOffset=(numArgs>7)?arguments[7]:false;var offset;if(numArgs>5){if(isOffset){offset=(window.screenY)?window.screenY:self.screenTop;offset=(offset)?offset:0}else{offset=0}offset+=arguments[5];windowParams+=(windowParams)?',':'';windowParams+='top='+offset+',screenY='+offset}else{windowParams+='top=0,screenY=0'}if(numArgs>6){if(isOffset){offset=(window.screenX)?window.screenX:self.screenLeft;offset=(offset)?offset:0}else{offset=0}offset+=arguments[6];windowParams+=',left='+offset+',screenX='+offset}if(screen.height){ht=screen.height}else if(window.document.body.clientHeight){ht=window.document.body.clientHeight}else if(window.innerHeight){ht=window.innerHeight}else if(document.documentElement.clientHeight){ht=document.documentElement.clientHeight}else{ht=580}if((height!=0)&&(height>ht)){height=ht}if(height!=0&&width!=0){windowParams+=',height='+height+',width='+width}else if(width!=0){windowParams+=',width='+width}windowObj=window.open(url,title,windowParams,false);if(windowObj){windowObj.focus()}return windowObj};function plx_Browser(){var d=document;this.agt=navigator.userAgent.toLowerCase();this.major=parseInt(navigator.appVersion);this.dom=(d.getElementById)?1:0;this.ns=(d.layers);this.ns4up=(this.ns&&this.major>=4);this.ns4=((navigator.appName=="Netscape")&&(parseInt(navigator.appVersion)==4));this.ns6=(this.dom&&navigator.appName=="Netscape");this.op=this.agt.indexOf('opera')!=-1;this.ie=(d.all);this.ie4=(d.all&&!this.dom)?1:0;this.ie4up=(this.ie&&this.major>=4);this.ie5=(d.all&&this.dom);this.win=((this.agt.indexOf("win")!=-1)||(this.agt.indexOf("16bit")!=-1));this.mac=(this.agt.indexOf("mac")!=-1);this.gecko=(this.agt.indexOf("gecko")!=-1);this.safari=(this.agt.indexOf("safari")!=-1);this.sp2=(this.agt.indexOf('sv1')!=-1)}var brz=new plx_Browser();