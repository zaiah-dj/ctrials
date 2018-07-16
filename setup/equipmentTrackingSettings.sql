USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTrackingSettings]    Script Date: 7/16/2018 2:19:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTrackingSettings](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[settingGUID] [varchar](50) NULL,
	[settingDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

