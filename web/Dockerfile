FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy dependency file and install
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source code
COPY . /app/

# Expose port 5000 for Flask
EXPOSE 5000

# Run the Flask app
CMD ["python", "app.py"]
