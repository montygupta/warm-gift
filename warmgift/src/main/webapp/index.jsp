<!DOCTYPE html>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>

<%
    BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Live input record and playback</title>
  <style type='text/css'>
    ul { list-style: none; }
    #recordingslist audio { display: block; margin-bottom: 10px; }
    #downloadurl { display: block; margin-bottom: 10px; }
  </style>
</head>
<body>
       <form method="post" enctype="multipart/form-data">

  <h1>Record your voice using HTML5</h1>

  <button onclick="startRecording(this);">record</button>
  <button onclick="stopRecording(this);" disabled>stop</button>
  
  <h2>Recordings</h2>
  <ul id="recordingslist"></ul>
  
  <ul id="downloadurl"></ul>
  <br><br>
  <input type="button" value="Submit" onClick="uploadAudio();">
 
  
  <h2>Log</h2>
  <pre id="log"></pre>

  <script>
  var furl = "";
  function uploadAudio(){
	    var reader = new FileReader();
	    reader.onload = function(event){
	        var fd = new FormData();
	        var mp3Name = encodeURIComponent('audio_recording_' + new Date().getTime());
	        console.log("mp3name = " + mp3Name);
	        fd.append('myFile', furl);
	        //fd.append('myFile', mp3Name);

	        $.ajax({
	            type: 'POST',
	            url: '<%= blobstoreService.createUploadUrl("/upload") %>',
	            data: fd,
	            processData: false,
	            contentType: false
	        }).done(function(data) {
	            console.log(data);
	            data = "https://warm-gift.appspot.com" + data;
	            var li = document.createElement('li');
	            var hf = document.createElement('a');
	            hf.href = data;
	            li.appendChild(hf);
	          //  li.appendChild(hf);
	            downloadurl.appendChild(li);				
	            alert(data);
	        });
	    };      
	    reader.readAsDataURL(furl);
	}  
  
  function __log(e, data) {
    log.innerHTML += "\n" + e + " " + (data || '');
  }
  var audio_context;
  var recorder;
  function startUserMedia(stream) {
    var input = audio_context.createMediaStreamSource(stream);
    __log('Media stream created.');
    // Uncomment if you want the audio to feedback directly
    //input.connect(audio_context.destination);
    //__log('Input connected to audio context destination.');
    
    recorder = new Recorder(input);
    __log('Recorder initialised.');
  }
  function startRecording(button) {
    recorder && recorder.record();
    button.disabled = true;
    button.nextElementSibling.disabled = false;
    __log('Recording...');
  }
  function stopRecording(button) {
    recorder && recorder.stop();
    button.disabled = true;
    button.previousElementSibling.disabled = false;
    __log('Stopped recording.');
    
    // create WAV download link using audio data blob
    createDownloadLink();
    
    recorder.clear();
  }
  function createDownloadLink() {
    recorder && recorder.exportWAV(function(blob) {
      var url = URL.createObjectURL(blob);
      furl = blob;
      var li = document.createElement('li');
      var au = document.createElement('audio');
      var hf = document.createElement('a');
      
      au.controls = true;
      au.src = url;
      hf.href = url;
      hf.download = new Date().toISOString() + '.wav';
      hf.innerHTML = hf.download;
      li.appendChild(au);
    //  li.appendChild(hf);
      recordingslist.appendChild(li);
    });
  }
  window.onload = function init() {
    try {
      // webkit shim
      window.AudioContext = window.AudioContext || window.webkitAudioContext;
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia;
      window.URL = window.URL || window.webkitURL;
      
      audio_context = new AudioContext;
      __log('Audio context set up.');
      __log('navigator.getUserMedia ' + (navigator.getUserMedia ? 'available.' : 'not present!'));
    } catch (e) {
      alert('No web audio support in this browser!');
    }
    
    navigator.getUserMedia({audio: true}, startUserMedia, function(e) {
      __log('No live audio input: ' + e);
    });
  };
  </script>

  <script src="recorder.js"></script>
  <script src="js/jquery-1.11.0.min.js"></script>	
  </form>
</body>
</html>