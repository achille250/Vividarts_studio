# Import necessary modules from Flask
from flask import Flask, render_template, request, jsonify
import boto3
import uuid

# Create a Flask app
app = Flask(__name__)

# AWS S3 credentials (Replace these with your own credentials)
aws_access_key_id = ''
aws_secret_access_key = ''
aws_region = 'us-east-1'  # Update with your AWS region
bucket_name = 'vivid-arts'

# Create an S3 client
s3 = boto3.client('s3', aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, region_name=aws_region)

# Define the main route that renders the index.html page
@app.route('/')
def index():
    return render_template('index.html')

# Define the upload route to handle file uploads
@app.route('/upload', methods=['POST'])
def upload():
    if request.method == 'POST':
        # Get the uploaded file from the request
        uploaded_file = request.files['photo']

        if uploaded_file:
            try:
                # Generate a unique filename for the uploaded file
                file_extension = uploaded_file.filename.split('.')[-1]
                unique_filename = f'{str(uuid.uuid4())}.{file_extension}'

                # Save the file to the S3 bucket
                s3.upload_fileobj(uploaded_file, bucket_name, unique_filename)
                
                # Invoke the Lambda function for image processing
                invoke_lambda_function(unique_filename)

                # Provide feedback to the user
                response = {
                    'status': 'success',
                    'message': 'File uploaded successfully!',
                    'file_url': f'https://{bucket_name}.s3.amazonaws.com/{unique_filename}'
                }
                return jsonify(response)
            except Exception as e:
                # Handle exceptions and provide an error response
                response = {
                    'status': 'error',
                    'message': f'Error: {str(e)}'
                }
                return jsonify(response)

    # If no file is uploaded, return an error response
    response = {
        'status': 'error',
        'message': 'No file uploaded.'
    }
    return jsonify(response)

# Function to invoke the Lambda function with the uploaded filename
def invoke_lambda_function(filename):
    lambda_function_name = 'image-processing-lambda'  # Update with your Lambda function name

    # Use subprocess to invoke AWS CLI to trigger Lambda function
    subprocess.run(['aws', 'lambda', 'invoke', '--function-name', lambda_function_name, '--payload', f'{{"Records": [{{"s3": {{"bucket": {{"name": "{bucket_name}"}}, "object": {{"key": "{filename}"}}}}}}]}}'])

# Run the Flask app in debug mode
if __name__ == '__main__':
    app.run(debug=True)
