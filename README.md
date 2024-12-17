# Scale
 
Godot 4.2.1 (THIS IS NOT THE LATEST VERSION, YOU HAVE BEEN WARNED)
https://godotengine.org/download/archive/4.2-stable/


To Create Levels:

STEP 1 - Create Scene

Duplicate Template Scene, Give it a unique name starting with "level_" (it is advised not to follow with a number)
![image](https://github.com/user-attachments/assets/673f5eee-0e56-43b3-9724-5a3d12137ffe)
![image](https://github.com/user-attachments/assets/a94ddf42-de4b-4817-b673-9a3a80989f0d)

Save Scene With CTRL+S (Save Often)

STEP 2 - Draw Ground

Select Ground Object
![image](https://github.com/user-attachments/assets/029ec3d0-ba78-4638-bc4e-54a35dd83eef)
![image](https://github.com/user-attachments/assets/a55b5670-6743-49e5-9b92-d8ba0b4291d3)


Reset Polygon (Click The Circle Arrow)
![image](https://github.com/user-attachments/assets/b70af19f-17ca-4913-b121-eeb6b3bef8f1)

Select "Create Points"
![image](https://github.com/user-attachments/assets/5a33fcf8-e1e2-40e0-8002-e64244ec2668)

Click Screen To Add Points
![image](https://github.com/user-attachments/assets/77d87c9f-978a-4d59-8ee9-d7f2552f5a64)

Close Points To Finish
![image](https://github.com/user-attachments/assets/9fce44a0-f6ca-415f-86ea-4947ae1e89d4)

Click And Drag Points To Line The Up (Meticulously)
![image](https://github.com/user-attachments/assets/9dbba457-0ac5-4a8f-a76b-4f6b3a05623f)

Click An Edge To Add A Point
![image](https://github.com/user-attachments/assets/0a385e4c-1f4b-488b-8e73-2fe3e8659344)

Right-Click On Polygon Variable And Copy Value
![image](https://github.com/user-attachments/assets/b4fe59d7-4022-4dd1-ac79-beafe9c59025)

Paste Value Into Corresponding CollisionPolygon2D and Grass
![image](https://github.com/user-attachments/assets/97e61178-b4f0-46db-8186-6526902e008a)
![image](https://github.com/user-attachments/assets/3e9e9fb1-fbe1-4a59-a17e-ccee5b8f8975)

Grass Line May Require Extra Points To Fit,
![image](https://github.com/user-attachments/assets/8e31aa4d-93c3-45db-b42b-93cce868ecf6)

The Scale May Also Need To Be Flipped To Properly Wrap
![image](https://github.com/user-attachments/assets/f55c16c3-3d04-49d5-82cb-3d6b8a9b4050)


STEP 3 - Setup Player

Select The Player Object And Move Mode (W)
![image](https://github.com/user-attachments/assets/9ce0fb9f-86b4-4d3a-a156-216df689eaa0)

Click And Drag Player To Desired Position
![image](https://github.com/user-attachments/assets/ab1f6570-e33d-4737-bd63-71c377ec989a)


STEP 4 - Adjust Camera Bounds

Copy Player Position
![image](https://github.com/user-attachments/assets/853e8399-23e4-4268-a2c3-61f4b9da9c51)

Move Player To Edge Of Level
![image](https://github.com/user-attachments/assets/be373626-cb1c-4c2c-a1a3-381524700e49)

Select Camera2D and Limit
![image](https://github.com/user-attachments/assets/eb4537f9-f020-4bab-9c10-4aa2492581ba)
![image](https://github.com/user-attachments/assets/fdc39dc1-0f20-4755-84ed-ae518fd474fb)

Adjust Limit Until View Box (Purple) Is Fully Within Level Bounds
(Recomended Technique Is To Set Right/Left To Zero, Click And Drag Number Box Until View Box Lines Up)
![image](https://github.com/user-attachments/assets/3362c26b-3d59-4853-84c1-5e279fe14205)
Repeat For Left And Right

Paste Ball Position Value To Return To Set Value
![image](https://github.com/user-attachments/assets/1307611b-4e7a-422a-b98d-99769d1f4d88)


STEP 7 - Set Background

Delete Unwanted Background Sprites
![image](https://github.com/user-attachments/assets/4f061d89-9af1-4f77-a691-b521f17d3b81)

Adjust Sprite Bounds To Fit Level
![image](https://github.com/user-attachments/assets/6dcac346-898f-4b57-ba21-cecda738da58)
![image](https://github.com/user-attachments/assets/aee9dc30-aef2-4878-b07c-d33bf108ed83)

To Insert Custom Background, 

Select Sprite Folder, Drag Image Into Scene From File Manager
![image](https://github.com/user-attachments/assets/b1fb5fcf-3f98-468e-af07-5216ebfe2f0e)

Drag Texture From File Manager
![image](https://github.com/user-attachments/assets/dcab83b2-ceb9-40fa-a802-84e3298d2cad)



STEP 6 - Spikes

Copy A Row Of Spikes
![image](https://github.com/user-attachments/assets/5af6ed2d-13b8-445e-bbbd-48c320a63d4b)

Move Spikes To Desired Location
![image](https://github.com/user-attachments/assets/9da43492-615e-496a-8351-71cbf56b9c25)

Use Rotate Mode (E) To Rotate Spikes
![image](https://github.com/user-attachments/assets/d9b88d92-04fe-43a0-9fe0-2fe0ebe8bce0)
![image](https://github.com/user-attachments/assets/5f7e00d4-41d0-4fbc-9e44-7f6fac75bfff)

Copy Or Delete Spikes To Alter Length
![image](https://github.com/user-attachments/assets/4a86bf72-f361-4ad9-b6f3-a59f6af2fb33)

To Adjust Collision Box Size, Make Collision Shape Unique, Click And Drag Collision Shape Bounds
![image](https://github.com/user-attachments/assets/726f0385-e875-47d5-b090-b3024d4e5a2f)
![image](https://github.com/user-attachments/assets/1d7805fd-7b43-456a-9dbe-ca592002ace4)


STEP 7 - Pins

Duplicate Pin Object
![image](https://github.com/user-attachments/assets/cb94d017-5c25-4da4-b2ed-386fb06ae4eb)

Adjust Transform To Preference
![image](https://github.com/user-attachments/assets/380e1b69-06a6-42e1-b1e4-f93322190e01)
![image](https://github.com/user-attachments/assets/69d0f09d-d48d-43ca-baed-bdcbaa08c3e8)

Adjust Mass To Preference
![image](https://github.com/user-attachments/assets/dd0e4a9e-172f-44b3-834b-71b385c021b2)


STEP 8 - Fan

Copy Fan Object
![image](https://github.com/user-attachments/assets/13330ab4-a0b4-403f-8a1e-780559f0538c)
![image](https://github.com/user-attachments/assets/fc0ca304-26de-444b-93c6-7be446cb4a15)

Adjust Transform To Preference
![image](https://github.com/user-attachments/assets/176b25c7-8312-43a4-820d-b0533a38ad38)

Adjust Power And Collision Box (Make Sure Collision Box Is Unique On A Duplicated Object)
![image](https://github.com/user-attachments/assets/0db6c276-499a-42d5-9bb8-ba4a108257e9)
![image](https://github.com/user-attachments/assets/b34493dd-07b1-4458-a215-ff71d66d0def)

Adjust Particle Emitter To Fit Collision Box
![image](https://github.com/user-attachments/assets/954bc387-1b56-4165-ab7c-b503cc544fd1)
![image](https://github.com/user-attachments/assets/6542eb9b-884a-4b97-86f6-cfbe34c20d88)



STEP 9 - Scale

Move Scale To Desired Location, Copy And Place 1-3 In Level (In Game Setup Is Automatic)
![image](https://github.com/user-attachments/assets/9d7dc3c7-3843-4627-b91f-2800a405c663)
![image](https://github.com/user-attachments/assets/379ac0c5-97c1-44b4-9f48-5e4f145528da)
![image](https://github.com/user-attachments/assets/2d1dfdfa-1358-49af-9b9c-dad51a5dc153)

STEP 10 - Add Anything Else

Create new objects, scripts, physics materials... to fit your level, just make sure to keep things organised


STEP 11 - Finish

Move, Rotate, Copy Finish Pole
![image](https://github.com/user-attachments/assets/6bc072bb-a7e2-41fc-a2c0-7e4f3bd25101)
![image](https://github.com/user-attachments/assets/1484874b-a7da-43d7-b027-510c273c3278)


DO NOT SAVE CHANGES TO ANY OTHER SCENES, DOING SO WILL CREATE MERGE CONLICTS
