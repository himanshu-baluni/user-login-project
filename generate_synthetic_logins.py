import random
from datetime import datetime, timedelta
import pandas as pd

random.seed(42)

# ---- CONFIG ----
START_DATE = "2024-01-01"
END_DATE   = "2024-06-30"

TOTAL_USERS = 300   # adjust if needed
BASE_LOGIN_PROB = 0.03  # adjust to control total rows

# ----------------

def daterange(start, end):
    cur = start
    while cur <= end:
        yield cur
        cur += timedelta(days=1)

start = datetime.strptime(START_DATE, "%Y-%m-%d").date()
end = datetime.strptime(END_DATE, "%Y-%m-%d").date()

rows = []

for user_id in range(1, TOTAL_USERS + 1):
    # give each user a slightly different activity level
    user_prob = BASE_LOGIN_PROB + random.uniform(-0.01, 0.02)
    user_prob = max(0.001, min(user_prob, 0.20))

    for day in daterange(start, end):
        # weekend slightly higher probability
        if day.weekday() in (5, 6):
            p = min(user_prob + 0.01, 0.30)
        else:
            p = user_prob

        if random.random() < p:
            rows.append({
                "user_id": user_id,
                "login_date": day.strftime("%Y-%m-%d")
            })

df = pd.DataFrame(rows).sort_values(["user_id", "login_date"]).reset_index(drop=True)

print("Rows:", len(df))
print("Unique users:", df["user_id"].nunique())
print("Date range:", df["login_date"].min(), "to", df["login_date"].max())

df.to_csv("logins.csv", index=False)
print("Saved: logins.csv")
