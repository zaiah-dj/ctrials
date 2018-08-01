USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTracking]    Script Date: 7/16/2018 2:16:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTracking](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[siteGUID] [varchar](50) NULL,
	[equipmentGUID] [varchar](50) NULL,
	[settingGUID] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

