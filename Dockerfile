# Use an official Python runtime as a parent image
# python:3.11-slim-bullseye is a good choice for smaller image size
FROM python:3.11-slim-bullseye

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
# This step leverages Docker's caching: if requirements.txt doesn't change,
# this layer and subsequent layers are reused, speeding up builds.
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
# --no-cache-dir ensures pip doesn't store downloaded packages, keeping image size down
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container at /app
COPY . .

# Expose the port that Streamlit runs on (default is 8501)
EXPOSE 8501

# Command to run the Streamlit application
# This is the command that will be executed when the container starts
# --server.enableCORS false and --server.enableXsrfProtection false are often used for simpler deployments
CMD ["streamlit", "run", "USENT_0714.py", "--server.port", "8501", "--server.enableCORS", "false", "--server.enableXsrfProtection", "false"]
