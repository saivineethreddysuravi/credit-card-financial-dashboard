"""
Multimodal Credit Risk Engine (Day 11 Update)
---------------------------------------------
This module uses Gemini's gemini-embedding-2-preview to analyze 
multimodal transaction data (Text, Audio, Image).

These embeddings are used to:
1. Detect non-obvious fraud patterns in merchant interaction logs.
2. Analyze customer service audio logs for credit dispute indicators.
3. Validate physical receipt/document images against transaction records.
"""

from google import genai
from google.genai import types
import os

class CreditMultimodalEngine:
    def __init__(self, api_key=None):
        self.api_key = api_key or os.getenv("GOOGLE_API_KEY")
        self.client = genai.Client(api_key=self.api_key)

    def embed_transaction_data(self, merchant_notes=None, image_path=None, audio_path=None):
        """
        Embeds transaction-related multimodal data.
        """
        contents = []
        
        if merchant_notes:
            contents.append(merchant_notes)
        
        if image_path and os.path.exists(image_path):
            with open(image_path, "rb") as f:
                image_bytes = f.read()
                contents.append(types.Part.from_bytes(
                    data=image_bytes,
                    mime_type="image/png"
                ))

        if audio_path and os.path.exists(audio_path):
            with open(audio_path, "rb") as f:
                audio_bytes = f.read()
                contents.append(types.Part.from_bytes(
                    data=audio_bytes,
                    mime_type="audio/mpeg"
                ))

        if not contents:
            raise ValueError("No content provided for embedding.")

        result = self.client.models.embed_content(
            model="gemini-embedding-2-preview",
            contents=contents,
        )
        return result.embeddings

if __name__ == "__main__":
    print("Initializing Credit Multimodal Engine (Day 11)...")
    print("Model: gemini-embedding-2-preview integrated for Transaction Risk Analysis.")
