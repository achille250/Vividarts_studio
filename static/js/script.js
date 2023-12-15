function uploadFile() {
    var form = $('#uploadForm')[0];
    var data = new FormData(form);

    $.ajax({
        type: 'POST',
        url: '/upload',
        data: data,
        processData: false,
        contentType: false,
        cache: false,
        success: function (response) {
            displayUploadStatus(response);
        },
        error: function (error) {
            displayUploadStatus({ status: 'error', message: 'An unexpected error occurred.' });
        }
    });
}

function displayUploadStatus(response) {
    var statusDiv = $('#uploadStatus');
    statusDiv.empty();

    var alertClass = response.status === 'success' ? 'alert-success' : 'alert-danger';
    var alertMessage = $('<div>').addClass('alert ' + alertClass).text(response.message);

    if (response.status === 'success') {
        var fileLink = $('<a>').attr('href', response.file_url).text('View uploaded file');
        alertMessage.append('<br>', fileLink);
    }

    statusDiv.append(alertMessage);
}
