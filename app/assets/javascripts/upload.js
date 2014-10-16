	function previewImages() {
		var gallery = document.getElementById("preview-gallery");
		while (gallery.firstChild) gallery.removeChild(gallery.firstChild);
		var imageFiles = document.getElementById("upload-photo-form-file");
		if (imageFiles.files.length === 0) {
			gallery.innerHTML += '<div id="placeholder"><h3 class="placeholder-text">No image selected.</h3></div>';
		} else {
			var numRows = Math.ceil(imageFiles.files.length/3);	//find number of rows for images
			for (var i = 0; i < numRows; i++) {		//for each row, create a row div to the gallery
				var rowDiv = document.createElement('div');
				rowDiv.className = 'row';
				rowDiv.id = 'row' + i;
				gallery.appendChild(rowDiv);
			}
			//for each image, insert into appropriate row and column in the gallery
			for (var i = 0; i < imageFiles.files.length; i++) {
				(function(i) {
					var fileReader = new FileReader();
					fileReader.readAsDataURL(imageFiles.files[i]);
					fileReader.onload = function (e) {
						var rowDiv = document.getElementById('row' + Math.floor(i/3));	//get row number of the image
						var newDiv = document.createElement('div');
						newDiv.className = 'col-md-4 row-md-4';
						newDiv.innerHTML += '<div class="img-div">'
						+ '<img class="thumbnail-upload img-responsive" src=' + e.target.result + ' id=img-'+ i + '><span class="remove glyphicon glyphicon-remove"></span>'
						+ '<div class="btn-group">'
						+ '<button type="button" id="description-' + i + '" class="btn btn-default" data-toggle="tooltip" data-placement="top" title="Add description"><span class="glyphicon glyphicon-pencil"></span></button>'
						+ '<button type="button" id="date-' + i + '" class="btn btn-default" data-toggle="tooltip" data-placement="top" title="Select date"><span class="glyphicon glyphicon-calendar"></span></button>'
						+ '<button type="button" id="location-' + i + '" class="btn btn-default" data-toggle="tooltip" data-placement="top" title="Select location"><span class="glyphicon glyphicon-map-marker"></span></button></div>'
						+'<form id="descriptionForm-' + i +'" target="upload_iframe" method="post" enctype="multipart/form-data" style="display:none">' +
							'Title: <input id="upload-message-img' + i + '" type="text"></form>'
						+'<form id="dateForm-' + i +'" target="upload_iframe" method="post" enctype="multipart/form-data" style="display:none">' +
							'Date: <input class="datepicker" id="upload-date-img' + i + '" type="text"></form>'
						+'<form id="locationForm-' + i +'" target="upload_iframe" method="post" enctype="multipart/form-data" style="display:none">' +
							'Location: <div id="upload-location-img' + i + '"><select class="select-countries" id="select-country' + i + 
						'" class="demo-default" placeholder="Select a country...">' +
						'<%= escape_javascript(render :partial => "layouts/selectize") %></select></div></form>' +
						'</div></div>';

						rowDiv.appendChild(newDiv);	//register child div in the DOM
						$(".datepicker").datepicker({
							dateFormat: 'dd-mm-yy'
						});
						$("#select-country"+i).selectize();
						/*$(".remove").on('click',function() {
							$(this)
						});*/

						document.getElementById('description-'+i).onclick = function() { showForm("descriptionForm",i); hideForm("dateForm",i); hideForm("locationForm", i); };
						document.getElementById('date-'+i).onclick = function() { showForm("dateForm",i); hideForm("descriptionForm",i); hideForm("locationForm", i); };
						document.getElementById('location-'+i).onclick = function() { showForm("locationForm",i); hideForm("dateForm",i); hideForm("descriptionForm", i); };
						document.getElementById('img-'+i).onclick = function() { showEnlargedImage('img-' +i) }
					};
				})(i);
			}
		}
	}

	function showEnlargedImage(imgID) {
		var modal = document.getElementById("enlargedImageBody");
		while (modal.firstChild) modal.removeChild(modal.firstChild);
		var src = $("#" + imgID).clone();
		console.log(src);
		console.log(modal);
		$(modal).html(src);
		console.log(modal);
		$("#enlargedImage").modal('show');
		$("#enlargedImage").on('click',function() {
			$("#enlargedImage").modal('hide');
		});
	}

	function showForm(type, i) {
		document.getElementById(type + "-" + i).style.display = "block";
	}

	function hideForm(type, i) {
		document.getElementById(type + "-" + i).style.display = "none";
	}
	
</script>

<!--Sourced from https://gist.github.com/nseo/2910244-->
<script type="application/javascript">
	var accessToken;
	(function($) {
		$(document).bind("FBSDKLoaded", function() {
			FB.getLoginStatus(function(response){
			if (response.status == 'connected') {
			  accessToken = response.authResponse.accessToken;
			}
		  });
		});
	})(jQuery);
	  
	//Upload a local file image
	function fileUpload() {
	  //ask for upload photo permissions
	  FB.login(function(r) {}, {scope: 'publish_actions' });
		var imageFiles = document.getElementById("upload-photo-form-file");
		var description = document.getElementById("upload-message");
		var date = document.getElementById("upload-date");
		var location = document.getElementById("img-select-country");
		console.log(location);
		for (var i = 0; i < imageFiles.files.length; i++) {
			if (document.getElementById("upload-message-img" + i)) {
				description = document.getElementById("upload-message-img" + i);
			}
			if (document.getElementById("upload-date-img" + i)) {
				date = document.getElementById("upload-date-img" + i);
			}
			if (document.getElementById("select-country" + i)) {
				location = document.getElementById("select-country" + i);
				console.log(location);
			}
			$("#process-upload").modal("show");
			var f = new FormData();	//create upload photo formdata
			f.append("source", imageFiles.files[i]);
			f.append("message", description.value);
			f.append("backdated_time", date.value);
			var currLocation = location.options[location.selectedIndex].value;
			f.append("place", pageID(country(currLocation)));

			(function() {
            var fCopy = f;
				FB.api('/me/albums', function(response) {
					var album = response.data[0]; // Now, upload the image to first found album for easiness.
		          $.ajax({
		              url: 'https://graph.facebook.com/' + album.id + '/photos?access_token=' +  accessToken,
		              type: "POST",
		              data: fCopy,
		              processData: false,
		              contentType: false,
		              cache: false,
		              success: function (data) {
		                  console.log("success " + data);
		              },
		              error: function (shr, status, data) {
		                  console.log("error " + data + " Status " + shr.status);
		              },
		              complete: function () {
		                  console.log("Posted to facebook");
								$("#process-upload").hide();
								//window.location = "http://localhost:3000/todos/index";
		              }
		          });
				});
			})();
		}
	}
