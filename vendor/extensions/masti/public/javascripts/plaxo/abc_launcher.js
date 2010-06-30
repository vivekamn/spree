 registerNamespaces("Plaxo");
 Plaxo.Util.Timer.setTimersEnabled(false);
 Plaxo.byId=function(elem){
 	if(typeof elem=='string')
	{elem=document.getElementById(elem)	}
		return elem};
		Plaxo.Class={create:function()
		{
			return function()
			{this.initialize.apply(this,arguments)}}};
				Plaxo.ABLauncher=Plaxo.Class.create();
				Plaxo.ABLauncher.prototype={initialize:function(){
					Plaxo.Debug.trace('initializing');
					this.name="Plaxo.ABLauncher 1.0";
					this.abWin=null;
					this.textArea=null;
					this.currentEmails={}},
					dialogWidth:460,dialogHeight:480,toQueryString:function(options){
						var queryComponents=[];
						for(key in options){
							if(typeof options[key]=='function')
							continue;
							var queryComponent=encodeURIComponent(key)+'='+encodeURIComponent(options[key]);
							queryComponents.push(queryComponent)}
							return queryComponents.join('&')},
							showABChooser:function(textArea,plaxoHost,callbackPage,extraOptions){
								this.textArea=Plaxo.byId(textArea);
								if(!this.textArea){Plaxo.Debug.error("can't find text area -> aborting");
								return}this.currentEmails={};
								this.extractEmails(this.textArea.value);
								if(!this.abWin||this.abWin.closed){
									if(callbackPage.length>0&&callbackPage.charAt(0)!='/'){callbackPage='/'+callbackPage}var cb=location.protocol+'//'+location.host+callbackPage;
									extraOptions.cb=cb;extraOptions.host=location.href;extraOptions.ts=new Date().getTime();
									var qs=this.toQueryString(extraOptions);
									var url='https://'+plaxoHost+'/ab_chooser?'+qs;
									if(extraOptions.plaxoMembersOnly){url+='&direct=1'}
									else{
										var emails=this.getCurrentEmailList().join(',');
										url+='&t=import&emails='+escape(emails)}this.abWin=popup(url,"PlaxoABC",this.dialogWidth,this.dialogHeight,'resizable=no,scrollbars=no')}
										if(this.abWin){this.abWin.focus()}},getCurrentEmailList:
										function(){
											var emails=[];
											for(email in this.currentEmails){
												emails.push(email)
												}
												return emails},extractEmails:function(str){
													var index=0;while(true){index=str.indexOf('@',index);
													if(index==-1)break;var start=Plaxo.String.findBoundary(str,index-1,false);
													var end=Plaxo.String.findBoundary(str,index+1,true);
													var email=str.substring(start,end+1).toLowerCase();
													this.currentEmails[email]=1;index++}},hasCurrentEmail:function(email){
														return this.currentEmails[email.toLowerCase()]},addCheckedRecipients:function(text){
														if(!text)
														return false;
														if(!this.textArea){
															Plaxo.Debug.error('no text area to add recipients to');
															return false
															}
															var curText=this.textArea.value;
															if(curText&&!curText.trim().endsWith(',')&&curText.length > 0)curText+=', ';
															curText+=text;
															this.setTextAreaValue(curText);
															return true
															},setTextAreaValue:function(str){this.textArea.value=str}};
															Plaxo.abl=null;
 function showPlaxoABChooser(textArea,callbackPage,plaxoHost,extraOptions){ 
  	if (!Plaxo.abl) { 
		Plaxo.abl = new Plaxo.ABLauncher();
	}
	if (!plaxoHost) { 
		plaxoHost = 'www.plaxo.com';
	}
	if (!extraOptions) {
		extraOptions = {};
	}
	Plaxo.abl.showABChooser(textArea,plaxoHost,callbackPage,extraOptions)
}