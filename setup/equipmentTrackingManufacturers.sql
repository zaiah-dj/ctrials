USE [motrpac]
GO

/****** Object:  Table [dbo].[equipmentTrackingManufacturers]    Script Date: 7/16/2018 2:18:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[equipmentTrackingManufacturers](
	[recID] [int] IDENTITY(1,1) NOT NULL,
	[d_inserted] [datetime] NULL,
	[insertedBy] [varchar](50) NULL,
	[deleted] [int] NULL,
	[deletedBy] [varchar](50) NULL,
	[d_deleted] [datetime] NULL,
	[deleteReason] [varchar](max) NULL,
	[manufacturerGUID] [varchar](50) NULL,
	[manufacturerDescription] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

