USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTrackingEquipment]    Script Date: 7/16/2018 2:17:11 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTrackingEquipment](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[siteGUID] [varchar](50) NULL,
	[machineGUID] [varchar](50) NULL,
	[equipmentGUID] [varchar](50) NULL,
	[exerciseGUID] [varchar](50) NULL,
	[active] [int] NULL,
	[interventionGUID] [varchar](50) NULL,
	[versionText] [varchar](max) NULL,
	[dateVersionChanged] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

