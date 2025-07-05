from locust import HttpUser, task, constant
from locust.exception import StopUser
import logging

class ChatUser(HttpUser):
    wait_time = constant(0)  # No delay between tasks

    @task
    def send_message(self):
        response = self.client.post("http://192.168.10.5:8080/query", json={"message": "Hello, world!","image":""})
        # assert response.status_code == 200
        # Log the request and response
        f = open("gem_resp.txt", "a")
        f.write(f"{response} === {response.text}\n")
        f.close()
        logging.info("Request message: %s", "Hello, world!")
        logging.info("Response: %s", response.text)
        raise StopUser


# For web UI
# locust -f scalability_test.py --host http://192.168.10.5:8080

# for cli
# locust -f locustfile.py --host https://your-backend-api --headless -u 100 -r 10 -t 30s
# -u 100 = 100 users
# -r 10 = spawn 10 users/second
# -t 30s = run for 30 seconds