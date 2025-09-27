
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ARG REQUIREMENTS=prod
ENV REQUIREMENTS=$REQUIREMENTS


# Set work directory
WORKDIR /app

# Install project dependencies
# Using requirements-prod.txt for production, fall back to requirements.txt if not found
COPY bot/requirements.txt bot/requirements-prod.txt ./bot/
RUN if [ "$REQUIREMENTS" = "prod" ]; then \
        pip install --no-cache-dir -r ./bot/requirements-prod.txt; \
    else \
        pip install --no-cache-dir -r ./bot/requirements.txt; \
    fi


# Copy the rest of the application code
COPY bot ./bot

# Expose the port the app runs on (modify if your app uses a different port)
ENV PORT=10000
EXPOSE 10000


# Health check (optional)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Command to run the application (modify based on your entrypoint)
# Option 1: If running a Flask server
CMD ["python", "bot/flask_server.py"]

# Alternative options (uncomment one if needed):
# Option 2: If running with Gunicorn (recommended for production)
# CMD ["gunicorn", "--bind", "0.0.0.0:5000", "flask_server:app", "--workers", "4"]