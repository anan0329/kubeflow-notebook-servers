import yaml
from transformers import AutoTokenizer, AutoModelForCausalLM
from huggingface_hub.commands.user import login


with open('/token.yml', 'r') as file:
    token = yaml.safe_load(file)

login(token['huggingface'])


MODEL_NAME = "meta-llama/Llama-2-7b-hf"
SAVED_MODEL = f"models/{MODEL_NAME}"


tokenizer = AutoTokenizer.from_pretrained(
    MODEL_NAME, 
    use_auth_token=True
)
model = AutoModelForCausalLM.from_pretrained(MODEL_NAME)

model.save_pretrained(SAVED_MODEL)