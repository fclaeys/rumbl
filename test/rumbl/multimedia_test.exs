defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Drama Action Comedy) do
        Multimedia.create_category!(name)
      end

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_category() do
          name
        end

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    alias Rumbl.Multimedia.Video

    @valid_attrs %{
      url: "http://local",
      title: "title",
      description: "desc"
    }
    @invalid_attrs %{
      url: nil,
      title: nil,
      description: nil
    }

    test "list_video/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert %Video{id: ^id1} = Multimedia.get_video!(id1)
    end

    test "create_video/2 with valid data create video" do
      owner = user_fixture()

      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, @valid_attrs)
      assert video.description == "desc"
      assert video.title == "title"
      assert video.url == "http://local"
    end

    test "create_video/2 with invalid data returns error changeset" do
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data update video" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert {:ok, %Video{} = video} = Multimedia.update_video(video, %{title: "new title"})
      assert video.title == "new title"
    end
  end
end
