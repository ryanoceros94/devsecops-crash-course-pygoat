# Use a stable Python 3.11 base image
FROM python:3.11-buster

# Set work directory
WORKDIR /app

# Install dependencies for psycopg2 and other necessary packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    dnsutils \
    libpq-dev \
    python3-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set environment variables with correct syntax
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Upgrade pip to a specific version if necessary
RUN python -m pip install --no-cache-dir pip==22.0.4

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . /app/

# Expose the desired port
EXPOSE 8000

# Apply database migrations
RUN python manage.py migrate

# Set the working directory to your Django project (if applicable)
WORKDIR /app/pygoat/

# Define the default command to run your application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "6", "pygoat.wsgi"]
