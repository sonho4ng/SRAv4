#!/bin/bash
echo "Installing requirements..."
pip install uv
uv sync
source .venv/bin/activate

echo 'Start run training scripts, logs are being saved to ${OUTPUT_DIR}/train.log'


bash ./mistral_tinyllama.sh 42 &
bash ./opt.sh 42 &

wait


echo "=== All done ==="