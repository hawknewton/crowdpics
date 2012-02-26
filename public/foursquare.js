
 var CLIENT_ID = "ZFFA3AXSPA5MEV2K2EGUBPWD4JAS0KS0ZMRK0G5TX5TOH2IR";
 var myData;
 var strWindowFeatures = "menubar=yes,location=yes,resizable=yes,scrollbars=yes,status=yes";  
  
 function getAccessToken(){
	console.log('Get token');
	var windowObjectReference = window.open('https://foursquare.com/oauth2/authenticate?client_id=ZFFA3AXSPA5MEV2K2EGUBPWD4JAS0KS0ZMRK0G5TX5TOH2IR&response_type=token&redirect_uri=http://crowdpics.net/test2.html', 'CrowdPics FourSquare oauth', strWindowFeatures);
	}
 
