CREATE TABLE [dbo].[ac_mtr_participants_v2](
	[p_id] [int] IDENTITY(1,1) NOT NULL,
	[participantGUID] [varchar](50) NOT NULL,
	[pid] [int] NOT NULL,
	[firstname] [varchar](256) NULL,
	[lastname] [varchar](256) NULL,
	[middlename] [varchar](256) NULL,
	[acrostic] [int] NULL,
	[randomGroupGUID] [varchar](50) NULL,
	[randomGroupCode] [varchar](50) NULL,
	[randomGroupDescription] [varchar](50) NULL,
	[siteID] [int] NULL,
	[siteName] [varchar](256) NULL,
	[siteGUID] [varchar](256) NULL,
	[d_session] [datetime] NULL
); 
