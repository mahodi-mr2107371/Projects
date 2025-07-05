import re
import pandas as pd
import matplotlib.pyplot as plt

# Load the log file
with open('RAG_evaluation_log.txt', 'r', encoding='utf-8') as f:
    log_data = f.read()

# Split into test case blocks
test_blocks = re.split(r'Metrics Summary', log_data)[1:]

# Initialize lists
results = []

for block in test_blocks:
    # Extract score
    score_match = re.search(r'score:\s*([\d.]+)', block)
    score = float(score_match.group(1)) if score_match else None

    # Extract pass/fail
    pass_fail = '✅' in block

    # Extract actual vs expected (optional)
    actual_match = re.search(r'actual output:\s*(.+)', block)
    expected_match = re.search(r'expected output:\s*(.+)', block)
    actual_output = actual_match.group(1).strip() if actual_match else ''
    expected_output = expected_match.group(1).strip() if expected_match else ''
    match = actual_output == expected_output

    results.append({
        'Score': score,
        'Passed': pass_fail,
        'Match': match,
        'Actual': actual_output,
        'Expected': expected_output
    })

# Convert to DataFrame
df = pd.DataFrame(results)

# Plot: Pass/Fail bar chart
pass_fail_counts = df['Passed'].value_counts()
pass_fail_counts.plot(kind='bar', color=['green', 'red'])
plt.title('Test Case Results')
plt.xticks([0, 1], ['Passed', 'Failed'], rotation=0)
plt.ylabel('Number of Test Cases')
plt.tight_layout()
plt.savefig('pass_fail_bar_chart.png')
plt.show()

# # Plot: Score distribution
# df['Score'].plot(kind='hist', bins=20, color='skyblue', edgecolor='black')
# plt.title('Score Distribution')
# plt.xlabel('Score')
# plt.ylabel('Number of Test Cases')
# plt.tight_layout()
# plt.savefig('score_histogram.png')
# plt.show()

df['Passed'].value_counts().plot(
    kind='pie', labels=['Passed', 'Failed'], autopct='%1.1f%%',
    colors=['green', 'red'], startangle=90
)
plt.title('Pass Rate')
plt.ylabel('')
plt.tight_layout()
plt.show()



#python results.py
