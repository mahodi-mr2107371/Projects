# Guide for setting up the Project
# Backend:

- Make sure the VS Code installed along with python.
- Open the 'app' directory in VS Code. 'app' directory can be found inside 'back-end' directory. Make sure when you open the project in VS Code, 'app' should be the root of the project.
- Check if there is a ```.venv``` folder inside 'app' directory.
- If there is no ```.venv``` folder then follow the steps below:
	- You will find ```requirments.txt ``` file by navigating to ```back-end/app ```
	- Press ```ctrl + shift + p``` to get following menu:

		![Image 1](./images/image%201.png)


	- Select the "Python: Select Interpreter" option. You will see the following

		![Image 2](./images/image%202.png)
	
	- Select "Create Virtual Environment" option. then select ```Venv``` option. You will then see the following:

		![Image 3](./images/image%203.png)

	- Select python. It will ask you to use ```requirments.txt ``` to install all required libraries as shown below:
		![Image 4](./images/image%204.png)

	- Press "OK" and it will create a ```.venv``` and automatically install all required libraries required to run the project.

- To run the server run this command in the VS Code terminal: 
	```bash
	python -m app.main
	```
- Make sure you are outside of the 'app' directory before running the above command. An example is shown below:
	![Image 5](./images/image%205.png)

- To get out of 'app' directory simply do ```cd ../``` and it will take you to "back-end".
- When you get the above, it means your server has started.
- However, if you want to run any other file for testing purposes just use the command below but make sure you are in that files directory
```bash
python <filename.py>
```

- Make sure you have ```.env``` file inside backend directory (app/backend/.env)
- ```.env``` contains all the API keys needed for project
- For Gemini API key you need to get the API key from [Google studio AI]([Get a Gemini API key  |  Google AI for Developers](https://ai.google.dev/gemini-api/docs/api-key))
- Once you get the API key add the following in ```.env``` file and save it:
```
API_KEY=<your_api_key>
```
# Self hosting Supabase:

- It is your choice whether to self host Supabase or not
- In our case we used both the online version and self hosted(only for image embeddings)
- If you want to self host do the following:
	1. **Prerequisites**
		Make sure you have these installed:
		- [Docker]([Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop/))
		- [Git](https://git-scm.com/ )  
	2. Clone the Supabase Self-host Repo:
	```bash
	git clone https://github.com/supabase/supabase.git
	```
	3. Open the Supabase directory and go to docker folder --> supabase/docker
	4. Once there, open cmd and do following mentioned below.
	5. Configure Environment Variables:
	```
	bash
	cp .env.example .env
	```
	6. Start Supabase Locally
	```bash
	docker compose up
	```
	7. Access the Services:
		- Supabase Studio: [http://localhost:3000](http://localhost:3000)
		- API: [http://localhost:8000](http://localhost:8000)
		- Postgres: exposed on port 5432 (for direct DB access)
- It is up to you whether to have embeddings table in self hosted supabase or in the online version.
- All data can be found in backend files if you navigate to back-end/app/backend/supabase data. You will csv files there. All you need to do is create a embeddings table with required columns (similar to csv file columns) and import those csv files. Use supabase dashboard for this.
- It is also important have Supabase URL and key in ```.env``` file created earlier like this:
```
SUPABASE_URL=<your_supabase_url>
SUPABASE_KEY=<your_supabase_key>
```
- Both URL and key can be found once you setup supabase 
### Steps to Get Supabase URL and API Key:

1. **Go to [https://supabase.com](https://supabase.com)**  
    Log in to your Supabase account. For self hosted supabase check the [link]([Self-Hosting with Docker | Supabase Docs](https://supabase.com/docs/guides/self-hosting/docker)) You will find a section called [Dashboard authentication](https://supabase.com/docs/guides/self-hosting/docker#dashboard-authentication)"
2. **Open Your Project**  
    Select the project you want to use.
3. **Navigate to Project Settings**
    - On the left sidebar, click on `Project Settings`.   
4. **Click on "Data API"**
    - Under `Settings`, click on **API**.
    - Here you will find:
        - **Project URL** (your Supabase URL)    
        - **anon/public API Key** (safe to use on the client)    
        - **service_role Key** (secret, use only on the backend)
- Also make sue to add the following code in sql editor in supabase dashboard
- The first line should be executed first before creating embeddings table so that you can have vector as data type for embeddings column.
```sql
CREATE EXTENSION IF NOT EXISTS vector;


CREATE FUNCTION match_images(query_embedding vector(1536), match_count int)

RETURNS TABLE(label TEXT, plantName TEXT, similarity FLOAT)

LANGUAGE SQL STABLE

AS $$

  SELECT embeddings.label, embeddings."plantName",

         1 - (embeddings."imageEmbedding" <=> query_embedding) AS similarity

  FROM embeddings

  ORDER BY embeddings."imageEmbedding" <=> query_embedding

  LIMIT match_count;

$$;
```
- You can also add indexing for vector search. More information on this can be found [here]([Vector indexes | Supabase Docs](https://supabase.com/docs/guides/ai/vector-indexes))
# Frontend:

- To install Flutter please see this [link]([Make Android apps | Flutter](https://docs.flutter.dev/get-started/install/windows/mobile)) --> For Windows
- For MAC : click [here]([Make iOS apps | Flutter](https://docs.flutter.dev/get-started/install/macos/mobile-ios))
- All the required information is in the links above
- To run the app you can also use a physical phone by connecting it to your computer using a wire and selecting your phone when debugging.
- Steps to connect physical phone are mentioned [here]([How to Set Up Your Physical Device to Run Your Flutter Project in VSCode | by Fatuma Yattani | Medium](https://medium.com/@fyattani/how-to-set-up-your-physical-device-to-run-your-flutter-project-in-vscode-019a5fc7b71e))
 
