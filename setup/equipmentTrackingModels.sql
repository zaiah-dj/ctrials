USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTrackingModels]    Script Date: 7/16/2018 2:18:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTrackingModels](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[modelGUID] [varchar](50) NULL,
	[modelDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

