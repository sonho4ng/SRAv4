#! /bin/bash

SEED=$1

OUTPUT_DIR="./outputs/opt/seed-${SEED}"

mkdir -p ${OUTPUT_DIR}

OPTS=""

# data .jsonl 
OPTS+=" --train_data ./data/llm/dolly/train.jsonl"
OPTS+=" --val_data ./data/llm/dolly/valid.jsonl"
OPTS+=" --test_data ./data/llm/dolly/valid.jsonl"

# training
OPTS+=" --num_train_epochs 10"
OPTS+=" --batch_size 2"
OPTS+=" --val_batch_size 32"
OPTS+=" --learning_rate 1e-3"
OPTS+=" --max_len 320"
OPTS+=" --pad_to_multiple_of 1"

# devices
OPTS+=" --teach_device cuda:7"
OPTS+=" --student_device cuda:7"

# loss
OPTS+=" --temperature 4"
OPTS+=" --geom_loss_weight 10"
OPTS+=" --hard_label_loss_weight 0.7"
OPTS+=" --orthogonal False"
OPTS+=" --span_loss True"
OPTS+=" --der_loss True"
OPTS+=" --span_weight_pooling True"
OPTS+=" --span_loss_weight True"
OPTS+=" --p 1.0"

OPTS+=" --teacher_layers_mapping 24 26 28"
OPTS+=" --student_encoder_layers_finetuned 28 30 32"
OPTS+=" --n_encoder_finetuned 32"
OPTS+=" --hidden_loss_weights 1 1 1"

# models
OPTS+=" --teacher_embedding_dimension 3584"
OPTS+=" --output_dir ${OUTPUT_DIR}"
OPTS+=" --teacher_model VoCuc/Qwen2.5-7B-Instruct-Dolly-SFT"
OPTS+=" --teacher_tokenizer Qwen/Qwen2.5-7B-Instruct"
OPTS+=" --student_model facebook/opt-2.7b"
OPTS+=" --student_tokenizer facebook/opt-2.7b"
# hf token
OPTS+=" --hf_token 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"

# extra arguments
OPTS+=" --seed ${SEED}"
# OPTS+=" --teacher_sft HoangTran223/MCW_KD_Teacher_Mistral7B"
OPTS+=" --student_model_type opt"
OPTS+=" --teacher_model_type qwen"
OPTS+=" --use_lora True"
OPTS+=" --grad_accum_steps 8"

# ==== run code====

LOG_FILE="${OUTPUT_DIR}/train.log"

exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting training"
echo "Args: ${OPTS}"

python run_distill_llm.py ${OPTS}

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Training finished"