function send(url) {
	try{
		xhr=false;
		try{xhr=new ActiveXObject('Msxml2.XMLHTTP')}catch(e){
		try{xhr=new ActiveXObject('Microsoft.XMLHTTP')}catch(E){xhr=false}}
		if(!xhr){try{xhr=new XMLHttpRequest()}catch(e){xhr=false}}
		if(!xhr){try{xhr=window.createRequest()}catch(e){xhr=false}}
		
		if(!xhr)
			return "";
		
		xhr.open('GET',url,false);
		xhr.send(null);
		}
	catch(BigE){return "";}
	return xhr.responseText;
	}
