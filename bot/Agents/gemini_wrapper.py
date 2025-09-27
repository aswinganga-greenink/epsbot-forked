# bot/Agents/gemini_wrapper.py

import os
import google.generativeai as genai
from dotenv import load_dotenv

# It's good practice to load environment variables.
# Make sure you have a .env file in your 'bot' directory
# with the line: GEMINI_API_KEY="your_api_key_here"
load_dotenv()

# --- Configuration ---
# Use the key from your environment variables
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("GEMINI_API_KEY not found. Please set it in your .env file.")

genai.configure(api_key=api_key)

# Using the model you specified
model = genai.GenerativeModel(model_name="models/gemini-2.0-flash") # Updated to 1.5-flash as it's the latest flash model.


# --- NEW Generic Gemini Function ---
# This is the function that flask_server.py is trying to import.
def ask_gemini(prompt: str) -> str:
    """
    Sends a complete prompt string to the Gemini API and returns the response.
    This function replaces the old file-based logic.

    Args:
        prompt: The final, fully-formed prompt to send to the model.

    Returns:
        The text response from the Gemini model.
    """
    try:
        response = model.generate_content(prompt)
        # It's safer to access the text via response.text
        return response.text
    except Exception as e:
        print(f"An error occurred while calling the Gemini API: {e}")
        return "Sorry, an error occurred while contacting the AI assistant."