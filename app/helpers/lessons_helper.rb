module LessonsHelper
  def correct_answer answer_id
    answer_id.nil? ? false : Answer.find_by(id: answer_id).is_correct
  end
end
