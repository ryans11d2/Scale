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


DO NOT SAVE CHANGES TO ANY OTHER SCENES, DOING SO WILL CREATE MERGE CONLICTS
