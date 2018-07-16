USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTrackingExercises]    Script Date: 7/16/2018 2:17:28 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTrackingExercises](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[exerciseGUID] [varchar](50) NULL,
	[exerciseDescription] [varchar](max) NULL,
	[exerciseOrder] [int] NULL,
	[formVariableName] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

