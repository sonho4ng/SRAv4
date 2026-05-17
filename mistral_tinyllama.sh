#! /bin/bash

SEED=$1

OUTPUT_DIR="./outputs/tiny_llama/seed-${SEED}"

mkdir -p ${OUTPUT_DIR}

OPTS=""

# data .jsonl 
OPTS+=" --train_data ./data/llm/dolly/train.jsonl"
OPTS+=" --val_data ./data/llm/dolly/valid.jsonl"
OPTS+=" --test_data ./data/llm/dolly/valid.jsonl"

# training
OPTS+=" --num_train_epochs 10"
OPTS+=" --batch_size 4"
OPTS+=" --val_batch_size 32"
OPTS+=" --learning_rate 1e-3"
OPTS+=" --max_len 320"
OPTS+=" --pad_to_multiple_of 1"

# devices
OPTS+=" --teach_device cuda:6"
OPTS+=" --student_device cuda:6"

# loss
OPTS+=" --hard_label_loss_weight 0.5"
OPTS+=" --geom_loss_weight 10"
OPTS+=" --orthogonal False"
OPTS+=" --span_loss True"
OPTS+=" --der_loss True"
OPTS+=" --span_weight_pooling True"
OPTS+=" --span_loss_weight True"
OPTS+=" --p 1.0"

OPTS+=" --teacher_layers_mapping 28 30 32"
OPTS+=" --student_encoder_layers_finetuned 18 20 22"
OPTS+=" --n_encoder_finetuned 22"
OPTS+=" --hidden_loss_weights 1 1 1"

# models
OPTS+=" --teacher_embedding_dimension 4096"
OPTS+=" --output_dir ${OUTPUT_DIR}"
OPTS+=" --teacher_model VoCuc/Mistral7B_Dolly_SFT"
OPTS+=" --teacher_tokenizer mistralai/Mistral-7B-v0.1"
OPTS+=" --student_model TinyLlama/TinyLlama-1.1B-intermediate-step-1431k-3T"
OPTS+=" --student_tokenizer TinyLlama/TinyLlama-1.1B-intermediate-step-1431k-3T"

# hf token
OPTS+=" --hf_token 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"

# extra arguments
OPTS+=" --seed ${SEED}"
# OPTS+=" --teacher_sft HoangTran223/MCW_KD_Teacher_Mistral7B"
OPTS+=" --student_model_type tinyllama"
OPTS+=" --teacher_model_type mistral"
OPTS+=" --use_lora True"
OPTS+=" --grad_accum_steps 4"

# ==== run code====

LOG_FILE="${OUTPUT_DIR}/train.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting training"
echo "Args: ${OPTS}"

python run_distill_llm.py ${OPTS}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Training finished"